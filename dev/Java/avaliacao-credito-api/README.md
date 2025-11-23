# API de Avaliação de Crédito - Spring Boot

Esta é uma API REST desenvolvida em Spring Boot para avaliar solicitações de crédito baseada em múltiplas regras de negócio.

## 📋 Funcionalidades

- **RF001**: Verificação de Situação Cadastral (Fonte X)
- **RF002**: Correspondência de Nome (similaridade >= 70%)
- **RF003**: Verificação de Idade
- **RF004**: Correspondência de Endereço (similaridade >= 70%)
- **RF005**: Score de Crédito (deve ser > 700)
- **RF006**: Consulta Blocklist Interna

## 🚀 Tecnologias Utilizadas

- Java 17
- Spring Boot 3.2.0
- Spring Data JPA
- PostgreSQL
- Lombok
- Apache Commons Text (cálculo de similaridade)
- Springdoc OpenAPI (Swagger UI)
- Maven

## 📦 Estrutura do Projeto

```
src/main/java/com/neurotech/credito/
├── AvaliacaoCreditoApplication.java
├── client/
│   ├── FonteXClient.java
│   └── FonteYClient.java
├── config/
│   └── AppConfig.java
├── controller/
│   └── CreditoController.java
├── dto/
│   ├── AvaliacaoCreditoResponseDTO.java
│   ├── DadosSolicitanteDTO.java
│   └── ResultadoRegraDTO.java
├── exception/
│   └── GlobalExceptionHandler.java
├── model/
│   ├── Blocklist.java
│   ├── FonteXResponse.java
│   ├── FonteYResponse.java
│   └── LogAvaliacao.java
├── repository/
│   ├── BlocklistRepository.java
│   └── LogAvaliacaoRepository.java
└── service/
    └── AvaliacaoCreditoService.java
```

## ⚙️ Configuração

### Pré-requisitos

- Java 17+
- Maven 3.6+
- PostgreSQL 12+

### Configuração do Banco de Dados

1. Crie um banco de dados PostgreSQL:

```sql
CREATE DATABASE credito_db;
```

2. Configure as credenciais no arquivo `application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/credito_db
    username: seu_usuario
    password: sua_senha
```

### URLs das APIs Externas

Configure as URLs das APIs externas no `application.yml`:

```yaml
api:
  fontex:
    url: http://api.fontex.com/v1
  fontey:
    url: http://api.fontey.com/v1
```

## 🏃 Como Executar

### Compilar o projeto:

```bash
mvn clean install
```

### Executar a aplicação:

```bash
mvn spring-boot:run
```

Ou execute diretamente o JAR:

```bash
java -jar target/avaliacao-credito-api-1.0.0.jar
```

A API estará disponível em: `http://localhost:8080`

## 📚 Documentação da API (Swagger)

Acesse a documentação interativa da API:

- Swagger UI: `http://localhost:8080/swagger-ui.html`
- OpenAPI JSON: `http://localhost:8080/api-docs`

## 🔌 Endpoints Principais

### POST /api/v1/credito/avaliar

Avalia uma solicitação de crédito.

**Request Body:**

```json
{
  "cpf": "12345678901",
  "nome": "João da Silva",
  "idade": 35,
  "endereco": "Rua Example, 123, São Paulo - SP"
}
```

**Response:**

```json
{
  "cpf": "12345678901",
  "dataAvaliacao": "2025-11-23T10:30:00",
  "resultadosRegras": [
    {
      "regra": "RF001 - Situação Cadastral",
      "valorConsultado": "Regular",
      "aprovado": true,
      "observacao": "Situação cadastral deve ser 'Regular'"
    },
    {
      "regra": "RF006 - Consulta Blocklist",
      "valorConsultado": "Não",
      "aprovado": true,
      "observacao": "CPF não deve constar na blocklist"
    },
    {
      "regra": "RF005 - Score de Crédito",
      "valorConsultado": 750,
      "aprovado": true,
      "observacao": "Score deve ser superior a 700"
    },
    {
      "regra": "RF002 - Correspondência de Nome",
      "valorConsultado": "95.00%",
      "aprovado": true,
      "observacao": "Similaridade entre nomes deve ser >= 70%"
    },
    {
      "regra": "RF003 - Verificação de Idade",
      "valorConsultado": "Informada: 35 | Calculada: 35",
      "aprovado": true,
      "observacao": "Idade informada deve corresponder à idade calculada"
    },
    {
      "regra": "RF004 - Correspondência de Endereço",
      "valorConsultado": "85.00%",
      "aprovado": true,
      "observacao": "Similaridade entre endereços deve ser >= 70%"
    }
  ],
  "aprovacaoGeral": true,
  "totalRegrasAprovadas": 6,
  "totalRegras": 6
}
```

### GET /api/v1/credito/health

Verifica se o serviço está ativo.

## 🗄️ Banco de Dados

### Tabelas Principais

#### blocklist
- Armazena CPFs bloqueados
- Campos: id, cpf, motivo, data_inclusao, usuario_inclusao, ativo

#### log_avaliacao
- Registra histórico de avaliações
- Campos: id, cpf, data_avaliacao, aprovacao_geral, total_regras_aprovadas, total_regras, detalhes_json

## 🧪 Testes

Execute os testes com:

```bash
mvn test
```

## 📝 Notas Importantes

1. **Cálculo de Similaridade**: Utiliza o algoritmo Jaro-Winkler para calcular a similaridade entre strings (nomes e endereços).

2. **Log de Avaliações**: Todas as avaliações são registradas no banco de dados para auditoria.

3. **Validações**: Todos os campos de entrada são validados automaticamente usando Bean Validation.

4. **Tratamento de Erros**: Global exception handler implementado para respostas consistentes de erro.

## 🔒 Segurança

Para produção, considere adicionar:
- Spring Security para autenticação/autorização
- Rate limiting
- Criptografia de dados sensíveis
- HTTPS obrigatório

## 📄 Licença

Este projeto é um exemplo educacional desenvolvido para a Neurotech.
