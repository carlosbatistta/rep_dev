package com.neurotech.credito.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FonteXResponse {
    
    private String cpf;
    private String situacao; // Regular, Irregular, etc.
    private String nome;
    private LocalDate dataNascimento;
    private String endereco;
}
