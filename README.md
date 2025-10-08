# Hospital BI Dashboard (SQL) — Starter

Um mini-projeto **realista e didático** para demonstrar modelagem de dados, carga (seed), camadas de transformação e **consultas analíticas** focadas em KPIs hospitalares (taxa de ocupação, média de permanência, reinternações etc.).  
Feito para ser **fácil de rodar localmente** (ex.: PostgreSQL) e **fácil de avaliar por recrutadores**.

> **Por que este projeto é diferente?**  
> Em vez de um CRUD genérico, aqui mostramos **raciocínio analítico** e **decisões de modelagem** em um contexto de negócio. O repositório inclui scripts de schema, dados de exemplo, views analíticas e consultas de KPIs — tudo comentado de forma humana.

---

## 🎯 Objetivos de Aprendizagem
- Organizar um **mini DW/Datamart** com camadas: *raw → cleansed/analytics*.
- Demonstrar **boas práticas** de SQL (chaves, normalização mínima, views semânticas).
- Expor **KPIs hospitalares** comuns com queries claras e reproduzíveis.

## 🧱 Estrutura
```
hospital-bi-dashboard-sql/
├─ sql/
│  ├─ 00_schema.sql            # Tabelas (raw e analytics)
│  ├─ 01_seed.sql              # Carga de dados de exemplo
│  ├─ 02_views.sql             # Views analíticas (dimensões e fatos)
│  ├─ 03_procedures.sql        # Funções p/ KPIs
│  └─ 04_reports_examples.sql  # Consultas prontas p/ entrevistas
├─ data/
│  ├─ pacientes.csv
│  ├─ internacoes.csv
│  └─ altas.csv
└─ powerbi/
   └─ dataset_schema.json      # Esquema de importação sugerido
```

## ⚙️ Como rodar (PostgreSQL)
1. Crie um DB local, ex.: `CREATE DATABASE hospital_bi;`
2. Execute os scripts na ordem:
   - `sql/00_schema.sql`
   - `sql/01_seed.sql`
   - `sql/02_views.sql`
   - `sql/03_procedures.sql`
   - (opcional) `sql/04_reports_examples.sql`
3. Use as **views** e **funções** para explorar os KPIs.

> Dica: Se preferir Docker, crie um `docker-compose.yml` simples com Postgres e rode os scripts via `psql`. (Podemos adicionar isso numa próxima iteração.)

## 📊 KPIs incluídos
- **Taxa de ocupação por dia** (internações ativas / leitos)
- **Tempo médio de internação (LOS)**
- **Reinternações em 30 dias**
- **Taxa de mortalidade (mock)**
- **Entradas e saídas por período**

## 🧠 Decisões de Modelagem
- Separação de **pacientes**, **internações** e **altas** (permite medir permanência e desfechos).
- **Dimensão tempo** via view (gera calendário a partir das datas existentes).
- Views semânticas (`d_paciente`, `d_tempo`, `f_internacao`) para consumo por BI.

## 🧪 Amostras de perguntas (entrevista)
- “Como você calcularia a **taxa de ocupação** diária?”  
- “Qual a **média de permanência** por ala/médico/mês?”  
- “Como identificar **reinternações** em até 30 dias?”  

## 🗂️ Licença
MIT — use, modifique, teste e mostre seu raciocínio.

---

> Criado com carinho por Tiago Dotto — 2025-10-07
