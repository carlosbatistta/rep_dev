package com.neurotech.credito.repository;

import com.neurotech.credito.model.LogAvaliacao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LogAvaliacaoRepository extends JpaRepository<LogAvaliacao, Long> {
    
    List<LogAvaliacao> findByCpfOrderByDataAvaliacaoDesc(String cpf);
}
