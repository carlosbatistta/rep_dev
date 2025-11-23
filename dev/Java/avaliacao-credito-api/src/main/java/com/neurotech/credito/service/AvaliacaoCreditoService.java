package com.neurotech.credito.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.neurotech.credito.client.FonteXClient;
import com.neurotech.credito.client.FonteYClient;
import com.neurotech.credito.dto.AvaliacaoCreditoResponseDTO;
import com.neurotech.credito.dto.DadosSolicitanteDTO;
import com.neurotech.credito.dto.ResultadoRegraDTO;
import com.neurotech.credito.model.FonteXResponse;
import com.neurotech.credito.model.FonteYResponse;
import com.neurotech.credito.model.LogAvaliacao;
import com.neurotech.credito.repository.BlocklistRepository;
import com.neurotech.credito.repository.LogAvaliacaoRepository;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.text.similarity.JaroWinklerSimilarity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
public class AvaliacaoCreditoService {
    
    private final FonteXClient fonteXClient;
    private final FonteYClient fonteYClient;
    private final BlocklistRepository blocklistRepository;
    private final LogAvaliacaoRepository logAvaliacaoRepository;
    private final ObjectMapper objectMapper;
    private final JaroWinklerSimilarity jaroWinklerSimilarity;
    
    public AvaliacaoCreditoService(
            FonteXClient fonteXClient,
            FonteYClient fonteYClient,
            BlocklistRepository blocklistRepository,
            LogAvaliacaoRepository logAvaliacaoRepository,
            ObjectMapper objectMapper) {
        this.fonteXClient = fonteXClient;
        this.fonteYClient = fonteYClient;
        this.blocklistRepository = blocklistRepository;
        this.logAvaliacaoRepository = logAvaliacaoRepository;
        this.objectMapper = objectMapper;
        this.jaroWinklerSimilarity = new JaroWinklerSimilarity();
    }
    
    @Transactional
    public AvaliacaoCreditoResponseDTO avaliarCredito(DadosSolicitanteDTO solicitante) {
        log.info("Iniciando avaliação de crédito para CPF: {}", solicitante.getCpf());
        
        // Lista de resultados
        List<ResultadoRegraDTO> resultados = new ArrayList<>();
        
        // Consultas externas e internas
        FonteXResponse fonteX = fonteXClient.consultarDados(solicitante.getCpf());
        FonteYResponse fonteY = fonteYClient.consultarScore(solicitante.getCpf());
        boolean constaBlocklist = blocklistRepository.existsByCpfAndAtivoTrue(solicitante.getCpf());
        
        // RF001: SITUAÇÃO CADASTRAL (FONTE X)
        resultados.add(avaliarSituacaoCadastral(fonteX));
        
        // RF006: CONSULTA BLOCKLIST (INTERNA)
        resultados.add(avaliarBlocklist(constaBlocklist));
        
        // RF005: SCORE DE CRÉDITO (FONTE Y)
        resultados.add(avaliarScoreCredito(fonteY));
        
        // RF002: CORRESPONDÊNCIA DE NOME
        resultados.add(avaliarCorrespondenciaNome(solicitante.getNome(), fonteX.getNome()));
        
        // RF003: VERIFICAÇÃO DE IDADE
        resultados.add(avaliarIdade(solicitante.getIdade(), fonteX.getDataNascimento()));
        
        // RF004: CORRESPONDÊNCIA DE ENDEREÇO
        resultados.add(avaliarCorrespondenciaEndereco(solicitante.getEndereco(), fonteX.getEndereco()));
        
        // Calcular aprovação geral
        long regrasAprovadas = resultados.stream().filter(ResultadoRegraDTO::getAprovado).count();
        boolean aprovacaoGeral = regrasAprovadas == resultados.size();
        
        // Construir resposta
        AvaliacaoCreditoResponseDTO response = AvaliacaoCreditoResponseDTO.builder()
                .cpf(solicitante.getCpf())
                .dataAvaliacao(LocalDateTime.now())
                .resultadosRegras(resultados)
                .aprovacaoGeral(aprovacaoGeral)
                .totalRegrasAprovadas((int) regrasAprovadas)
                .totalRegras(resultados.size())
                .build();
        
        // Salvar log
        salvarLog(response);
        
        log.info("Avaliação concluída para CPF: {} - Aprovado: {}", solicitante.getCpf(), aprovacaoGeral);
        
        return response;
    }
    
    private ResultadoRegraDTO avaliarSituacaoCadastral(FonteXResponse fonteX) {
        boolean aprovado = "Regular".equalsIgnoreCase(fonteX.getSituacao());
        
        return ResultadoRegraDTO.builder()
                .regra("RF001 - Situação Cadastral")
                .valorConsultado(fonteX.getSituacao())
                .aprovado(aprovado)
                .observacao("Situação cadastral deve ser 'Regular'")
                .build();
    }
    
    private ResultadoRegraDTO avaliarBlocklist(boolean constaBlocklist) {
        return ResultadoRegraDTO.builder()
                .regra("RF006 - Consulta Blocklist")
                .valorConsultado(constaBlocklist ? "Sim" : "Não")
                .aprovado(!constaBlocklist)
                .observacao("CPF não deve constar na blocklist")
                .build();
    }
    
    private ResultadoRegraDTO avaliarScoreCredito(FonteYResponse fonteY) {
        boolean aprovado = fonteY.getScore() > 700;
        
        return ResultadoRegraDTO.builder()
                .regra("RF005 - Score de Crédito")
                .valorConsultado(fonteY.getScore())
                .aprovado(aprovado)
                .observacao("Score deve ser superior a 700")
                .build();
    }
    
    private ResultadoRegraDTO avaliarCorrespondenciaNome(String nomeSolicitante, String nomeFonteX) {
        double similaridade = calcularSimilaridade(nomeSolicitante, nomeFonteX);
        boolean aprovado = similaridade >= 0.70;
        
        return ResultadoRegraDTO.builder()
                .regra("RF002 - Correspondência de Nome")
                .valorConsultado(String.format("%.2f%%", similaridade * 100))
                .aprovado(aprovado)
                .observacao("Similaridade entre nomes deve ser >= 70%")
                .build();
    }
    
    private ResultadoRegraDTO avaliarIdade(Integer idadeSolicitante, LocalDate dataNascimento) {
        int idadeCalculada = calcularIdade(dataNascimento);
        boolean aprovado = idadeCalculada == idadeSolicitante;
        
        return ResultadoRegraDTO.builder()
                .regra("RF003 - Verificação de Idade")
                .valorConsultado("Informada: " + idadeSolicitante + " | Calculada: " + idadeCalculada)
                .aprovado(aprovado)
                .observacao("Idade informada deve corresponder à idade calculada")
                .build();
    }
    
    private ResultadoRegraDTO avaliarCorrespondenciaEndereco(String enderecoSolicitante, String enderecoFonteX) {
        double similaridade = calcularSimilaridade(enderecoSolicitante, enderecoFonteX);
        boolean aprovado = similaridade >= 0.70;
        
        return ResultadoRegraDTO.builder()
                .regra("RF004 - Correspondência de Endereço")
                .valorConsultado(String.format("%.2f%%", similaridade * 100))
                .aprovado(aprovado)
                .observacao("Similaridade entre endereços deve ser >= 70%")
                .build();
    }
    
    private double calcularSimilaridade(String texto1, String texto2) {
        if (texto1 == null || texto2 == null) {
            return 0.0;
        }
        
        String t1 = texto1.toLowerCase().trim();
        String t2 = texto2.toLowerCase().trim();
        
        return jaroWinklerSimilarity.apply(t1, t2);
    }
    
    private int calcularIdade(LocalDate dataNascimento) {
        if (dataNascimento == null) {
            return 0;
        }
        return Period.between(dataNascimento, LocalDate.now()).getYears();
    }
    
    private void salvarLog(AvaliacaoCreditoResponseDTO response) {
        try {
            String detalhesJson = objectMapper.writeValueAsString(response.getResultadosRegras());
            
            LogAvaliacao log = LogAvaliacao.builder()
                    .cpf(response.getCpf())
                    .dataAvaliacao(response.getDataAvaliacao())
                    .aprovacaoGeral(response.getAprovacaoGeral())
                    .totalRegrasAprovadas(response.getTotalRegrasAprovadas())
                    .totalRegras(response.getTotalRegras())
                    .detalhesJson(detalhesJson)
                    .build();
            
            logAvaliacaoRepository.save(log);
        } catch (Exception e) {
            log.error("Erro ao salvar log de avaliação", e);
        }
    }
}
