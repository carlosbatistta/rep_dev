-- Script SQL para criar as tabelas no PostgreSQL

-- Tabela Blocklist
CREATE TABLE IF NOT EXISTS blocklist (
    id BIGSERIAL PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    motivo VARCHAR(500) NOT NULL,
    data_inclusao TIMESTAMP NOT NULL,
    usuario_inclusao VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- Índice para melhorar performance de consultas
CREATE INDEX idx_blocklist_cpf ON blocklist(cpf);
CREATE INDEX idx_blocklist_ativo ON blocklist(ativo);

-- Tabela Log de Avaliação
CREATE TABLE IF NOT EXISTS log_avaliacao (
    id BIGSERIAL PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL,
    data_avaliacao TIMESTAMP NOT NULL,
    aprovacao_geral BOOLEAN NOT NULL,
    total_regras_aprovadas INTEGER,
    total_regras INTEGER,
    detalhes_json TEXT
);

-- Índices para melhorar performance
CREATE INDEX idx_log_avaliacao_cpf ON log_avaliacao(cpf);
CREATE INDEX idx_log_avaliacao_data ON log_avaliacao(data_avaliacao);

-- Inserir alguns dados de exemplo na blocklist
INSERT INTO blocklist (cpf, motivo, data_inclusao, usuario_inclusao, ativo)
VALUES 
    ('11111111111', 'Inadimplência recorrente', NOW(), 'sistema', TRUE),
    ('22222222222', 'Fraude detectada', NOW(), 'sistema', TRUE),
    ('33333333333', 'Processo judicial em andamento', NOW(), 'sistema', TRUE);

COMMENT ON TABLE blocklist IS 'Tabela que armazena CPFs bloqueados para análise de crédito';
COMMENT ON TABLE log_avaliacao IS 'Tabela que armazena histórico de todas as avaliações de crédito realizadas';
