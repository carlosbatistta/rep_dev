package com.neurotech.credito.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResultadoRegraDTO {
    
    private String regra;
    private Object valorConsultado;
    private Boolean aprovado;
    private String observacao;
}
