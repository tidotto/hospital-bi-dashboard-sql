-- 01_seed.sql
-- Popular dados de exemplo (mock).

INSERT INTO analytics.capacidade_leitos(ala, qtd_leitos) VALUES
  ('Ala 1', 20),
  ('Ala 2', 15),
  ('UTI', 10);

INSERT INTO raw.pacientes (cpf, nome, data_nascimento, sexo, cidade) VALUES
  ('111.111.111-11','Ana Souza','1985-03-12','F','Guaíba'),
  ('222.222.222-22','Carlos Lima','1979-07-22','M','Porto Alegre'),
  ('333.333.333-33','Marina Alves','1992-11-05','F','Canoas'),
  ('444.444.444-44','Tiago Dotto','1987-01-15','M','Guaíba');

INSERT INTO raw.internacoes (paciente_id, data_entrada, ala, leito, medico_responsavel, diagnostico) VALUES
  (1, '2025-09-01','Ala 1','101','Dr. Silva','Pneumonia'),
  (2, '2025-09-02','Ala 2','201','Dra. Marta','Fratura'),
  (3, '2025-09-03','UTI','U01','Dr. Souza','Sepse'),
  (1, '2025-09-20','Ala 1','102','Dr. Silva','Asma'),
  (4, '2025-09-25','Ala 2','202','Dra. Marta','Gastroenterite');

INSERT INTO raw.altas (internacao_id, data_alta, desfecho) VALUES
  (1,'2025-09-10','ALTA'),
  (2,'2025-09-05','ALTA'),
  (3,'2025-09-15','ALTA'),
  (4,'2025-09-25','ALTA');
-- Observação: a internação_id 5 permanece aberta para demonstrar ocupação atual.