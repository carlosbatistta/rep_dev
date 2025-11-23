package com.neurotech.credito.client;

import com.neurotech.credito.model.FonteYResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class FonteYClient {
    
    private final RestTemplate restTemplate;
    
    @Value("${api.fontey.url}")
    private String fonteYUrl;
    
    public FonteYClient(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    public FonteYResponse consultarScore(String cpf) {
        String url = String.format("%s/score?cpf=%s", fonteYUrl, cpf);
        
        try {
            return restTemplate.getForObject(url, FonteYResponse.class);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao consultar Fonte Y: " + e.getMessage(), e);
        }
    }
}
