package com.neurotech.credito.controller;

import com.neurotech.credito.dto.AvaliacaoCreditoResponseDTO;
import com.neurotech.credito.dto.DadosSolicitanteDTO;
import com.neurotech.credito.service.AvaliacaoCreditoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/credito")
@Tag(name = "Avaliação de Crédito", description = "Endpoints para avaliação de crédito")
public class CreditoController {
    
    private final AvaliacaoCreditoService avaliacaoCreditoService;
    
    public CreditoController(AvaliacaoCreditoService avaliacaoCreditoService) {
        this.avaliacaoCreditoService = avaliacaoCreditoService;
    }
    
    @PostMapping("/avaliar")
    @Operation(summary = "Avaliar solicitação de crédito", 
               description = "Avalia uma solicitação de crédito com base em múltiplas regras de negócio")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Avaliação realizada com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos"),
        @ApiResponse(responseCode = "500", description = "Erro interno do servidor")
    })
    public ResponseEntity<AvaliacaoCreditoResponseDTO> avaliarCredito(
            @Valid @RequestBody DadosSolicitanteDTO solicitante) {
        
        log.info("Recebida solicitação de avaliação de crédito para CPF: {}", solicitante.getCpf());
        
        try {
            AvaliacaoCreditoResponseDTO response = avaliacaoCreditoService.avaliarCredito(solicitante);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Erro ao avaliar crédito: {}", e.getMessage(), e);
            throw e;
        }
    }
    
    @GetMapping("/health")
    @Operation(summary = "Health check", description = "Verifica se o serviço está ativo")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("API de Avaliação de Crédito está funcionando!");
    }
}
