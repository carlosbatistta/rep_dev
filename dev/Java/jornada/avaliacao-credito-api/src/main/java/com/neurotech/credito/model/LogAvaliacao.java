package com.neurotech.credito.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "log_avaliacao")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LogAvaliacao {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String cpf;
    
    @Column(name = "data_avaliacao", nullable = false)
    private LocalDateTime dataAvaliacao;
    
    @Column(name = "aprovacao_geral", nullable = false)
    private Boolean aprovacaoGeral;
    
    @Column(name = "total_regras_aprovadas")
    private Integer totalRegrasAprovadas;
    
    @Column(name = "total_regras")
    private Integer totalRegras;
    
    @Column(columnDefinition = "TEXT")
    private String detalhesJson;
}
