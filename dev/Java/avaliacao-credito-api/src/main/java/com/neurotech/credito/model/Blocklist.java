package com.neurotech.credito.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "blocklist")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Blocklist {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String cpf;
    
    @Column(nullable = false)
    private String motivo;
    
    @Column(name = "data_inclusao", nullable = false)
    private LocalDateTime dataInclusao;
    
    @Column(name = "usuario_inclusao")
    private String usuarioInclusao;
    
    @Column
    private Boolean ativo = true;
}
