-- 00_schema.sql
-- Esquema base para mini-DW hospitalar (PostgreSQL).

DROP SCHEMA IF EXISTS raw CASCADE;
DROP SCHEMA IF EXISTS analytics CASCADE;
CREATE SCHEMA raw;
CREATE SCHEMA analytics;

-- RAW LAYER ---------------------------------------------------------
CREATE TABLE raw.pacientes (
  paciente_id        SERIAL PRIMARY KEY,
  cpf                VARCHAR(14),
  nome               TEXT NOT NULL,
  data_nascimento    DATE,
  sexo               CHAR(1) CHECK (sexo IN ('M','F')),
  cidade             TEXT
);

CREATE TABLE raw.internacoes (
  internacao_id      SERIAL PRIMARY KEY,
  paciente_id        INT REFERENCES raw.pacientes(paciente_id),
  data_entrada       DATE NOT NULL,
  ala                TEXT NOT NULL,
  leito              TEXT,
  medico_responsavel TEXT,
  diagnostico        TEXT
);

CREATE TABLE raw.altas (
  alta_id            SERIAL PRIMARY KEY,
  internacao_id      INT UNIQUE REFERENCES raw.internacoes(internacao_id),
  data_alta          DATE NOT NULL,
  desfecho           TEXT CHECK (desfecho IN ('ALTA','OBITO','TRANSFERENCIA'))
);

-- ANALYTICS LAYER (tabelas de apoio, se necessário) ----------------
CREATE TABLE analytics.parametros (
  chave TEXT PRIMARY KEY,
  valor TEXT NOT NULL
);

-- Parâmetro de capacidade (leitos por ala) para taxa de ocupação:
CREATE TABLE analytics.capacidade_leitos (
  ala TEXT PRIMARY KEY,
  qtd_leitos INT NOT NULL CHECK (qtd_leitos > 0)
);