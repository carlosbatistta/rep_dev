package com.neurotech.credito.client;

import com.neurotech.credito.model.FonteXResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class FonteXClient {
    
    private final RestTemplate restTemplate;
    
    @Value("${api.fontex.url}")
    private String fonteXUrl;
    
    public FonteXClient(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    public FonteXResponse consultarDados(String cpf) {
        String url = String.format("%s/consulta?cpf=%s", fonteXUrl, cpf);
        
        try {
            return restTemplate.getForObject(url, FonteXResponse.class);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao consultar Fonte X: " + e.getMessage(), e);
        }
    }
}
