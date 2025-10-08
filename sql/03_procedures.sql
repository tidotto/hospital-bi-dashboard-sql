-- 03_procedures.sql
-- Funções para KPIs (PostgreSQL).

-- Taxa de ocupação diária por ala
-- Definição: internacoes ativas no dia / capacidade da ala
CREATE OR REPLACE FUNCTION analytics.fn_taxa_ocupacao(p_data date, p_ala text)
RETURNS numeric AS $$
DECLARE
  ativas int;
  capacidade int;
BEGIN
  SELECT COUNT(*) INTO ativas
  FROM raw.internacoes i
  LEFT JOIN raw.altas a ON a.internacao_id = i.internacao_id
  WHERE i.ala = p_ala
    AND i.data_entrada <= p_data
    AND (a.data_alta IS NULL OR a.data_alta > p_data);

  SELECT qtd_leitos INTO capacidade
  FROM analytics.capacidade_leitos
  WHERE ala = p_ala;

  IF capacidade IS NULL OR capacidade = 0 THEN
    RETURN NULL;
  END IF;

  RETURN ROUND(100.0 * ativas / capacidade, 2);
END;
$$ LANGUAGE plpgsql;

-- Tempo médio de internação (LOS) por período
CREATE OR REPLACE FUNCTION analytics.fn_los_medio(p_inicio date, p_fim date)
RETURNS numeric AS $$
DECLARE
  media numeric;
BEGIN
  SELECT AVG(dias_internado)::numeric INTO media
  FROM analytics.f_internacao
  WHERE data_entrada >= p_inicio
    AND (data_alta <= p_fim OR data_alta IS NULL);
  RETURN ROUND(COALESCE(media,0),2);
END;
$$ LANGUAGE plpgsql;

-- Reinternações em 30 dias
-- Critério: mesma paciente, nova internação em até 30 dias após alta anterior
CREATE OR REPLACE FUNCTION analytics.fn_reinternacoes_30d()
RETURNS TABLE(paciente_id int, qtd_reinternacoes int) AS $$
BEGIN
  RETURN QUERY
  WITH altas AS (
    SELECT i.paciente_id, a.data_alta
    FROM raw.internacoes i
    JOIN raw.altas a ON a.internacao_id = i.internacao_id
  ),
  rein AS (
    SELECT a1.paciente_id,
           COUNT(*) AS qtd
    FROM altas a1
    JOIN raw.internacoes i2
      ON i2.paciente_id = a1.paciente_id
     AND i2.data_entrada > a1.data_alta
     AND i2.data_entrada <= a1.data_alta + INTERVAL '30 days'
    GROUP BY a1.paciente_id
  )
  SELECT paciente_id, qtd FROM rein;
END;
$$ LANGUAGE plpgsql;