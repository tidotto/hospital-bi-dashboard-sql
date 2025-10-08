-- 02_views.sql
-- Views analíticas (dimensões e fatos).

-- Dimensão paciente (projeção simples)
CREATE OR REPLACE VIEW analytics.d_paciente AS
SELECT
  p.paciente_id,
  p.nome,
  p.sexo,
  p.data_nascimento,
  date_part('year', age(current_date, p.data_nascimento))::int AS idade,
  p.cidade
FROM raw.pacientes p;

-- Dimensão tempo (derivada das datas existentes nas tabelas)
CREATE OR REPLACE VIEW analytics.d_tempo AS
WITH datas AS (
  SELECT data_entrada AS d FROM raw.internacoes
  UNION
  SELECT data_alta FROM raw.altas
)
SELECT DISTINCT
  d::date AS data,
  EXTRACT(ISODOW FROM d)::int AS dia_semana,
  EXTRACT(WEEK FROM d)::int AS semana_ano,
  EXTRACT(MONTH FROM d)::int AS mes,
  EXTRACT(YEAR FROM d)::int AS ano
FROM datas;

-- Fato de internação (com LOS)
CREATE OR REPLACE VIEW analytics.f_internacao AS
SELECT
  i.internacao_id,
  i.paciente_id,
  i.data_entrada,
  a.data_alta,
  i.ala,
  i.leito,
  i.medico_responsavel,
  i.diagnostico,
  CASE
    WHEN a.data_alta IS NOT NULL THEN GREATEST(1, (a.data_alta - i.data_entrada))
    ELSE GREATEST(1, (current_date - i.data_entrada))
  END::int AS dias_internado,
  CASE WHEN a.data_alta IS NULL THEN TRUE ELSE FALSE END AS internacao_aberta,
  a.desfecho
FROM raw.internacoes i
LEFT JOIN raw.altas a ON a.internacao_id = i.internacao_id;