-- 04_reports_examples.sql
-- Consultas prontas para entrevistas e screenshots.

-- 1) Taxa de ocupação diária por ala (intervalo)
SELECT d.data, ala, analytics.fn_taxa_ocupacao(d.data, ala) AS taxa_ocupacao_pct
FROM analytics.d_tempo d
CROSS JOIN (SELECT ala FROM analytics.capacidade_leitos) a
WHERE d.data BETWEEN '2025-09-01' AND current_date
ORDER BY d.data, ala;

-- 2) LOS médio no período
SELECT analytics.fn_los_medio('2025-09-01', CURRENT_DATE) AS los_medio_geral;

-- 3) Reinternações em 30 dias
SELECT * FROM analytics.fn_reinternacoes_30d() ORDER BY qtd_reinternacoes DESC;

-- 4) Top diagnósticos por tempo médio de internação
WITH base AS (
  SELECT diagnostico, AVG(dias_internado) AS los_medio
  FROM analytics.f_internacao
  GROUP BY diagnostico
)
SELECT * FROM base ORDER BY los_medio DESC;

-- 5) Ocupação atual por ala (hoje)
SELECT
  i.ala,
  COUNT(*) FILTER (WHERE a.data_alta IS NULL OR a.data_alta > CURRENT_DATE) AS internacoes_ativas_hoje,
  cl.qtd_leitos,
  ROUND(100.0 * (COUNT(*) FILTER (WHERE a.data_alta IS NULL OR a.data_alta > CURRENT_DATE)) / cl.qtd_leitos, 2) AS taxa_ocupacao_pct
FROM raw.internacoes i
LEFT JOIN raw.altas a ON a.internacao_id = i.internacao_id
JOIN analytics.capacidade_leitos cl ON cl.ala = i.ala
GROUP BY i.ala, cl.qtd_leitos
ORDER BY taxa_ocupacao_pct DESC;