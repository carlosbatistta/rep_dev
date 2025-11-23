package com.neurotech.credito.repository;

import com.neurotech.credito.model.Blocklist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BlocklistRepository extends JpaRepository<Blocklist, Long> {
    
    Optional<Blocklist> findByCpfAndAtivoTrue(String cpf);
    
    boolean existsByCpfAndAtivoTrue(String cpf);
}
