package com.neurotech.credito.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AvaliacaoCreditoResponseDTO {
    
    private String cpf;
    private LocalDateTime dataAvaliacao;
    private List<ResultadoRegraDTO> resultadosRegras;
    private Boolean aprovacaoGeral;
    private Integer totalRegrasAprovadas;
    private Integer totalRegras;
}
