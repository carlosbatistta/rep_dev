package com.neurotech.credito.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FonteYResponse {
    
    private String cpf;
    private Integer score;
    private String classificacao;
}
