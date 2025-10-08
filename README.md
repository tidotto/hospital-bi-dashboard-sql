# Hospital BI Dashboard (SQL)

Esse projeto nasceu da vontade de mostrar meu raciocínio em **modelagem de dados e análise**, e não apenas criar mais um CRUD de exemplo.  
Pensei em algo que fosse próximo da minha experiência real em hospital, mas simplificado para ser **fácil de entender, rodar e avaliar**.  

> 💡 A ideia é: em vez de código solto, aqui eu mostro **como eu pensaria em montar um mini datamart hospitalar** para responder perguntas de negócio (KPIs) de forma clara e reproduzível.

---

## 🎯 O que eu quis alcançar
- Simular um **mini DW/Datamart** em camadas (*raw → cleansed/analytics*).  
- Demonstrar **boas práticas** de SQL (uso de chaves, views semânticas, normalização mínima).  
- Expor **KPIs hospitalares comuns** com queries objetivas e comentadas.  

---

## 🧱 Estrutura que montei
```
hospital-bi-dashboard-sql/
├─ sql/
│  ├─ 00_schema.sql            # Criação das tabelas (raw e analytics)
│  ├─ 01_seed.sql              # Dados de exemplo
│  ├─ 02_views.sql             # Views analíticas (dimensões e fatos)
│  ├─ 03_procedures.sql        # Funções para cálculos de KPIs
│  └─ 04_reports_examples.sql  # Consultas prontas para entrevistas
├─ data/
│  ├─ pacientes.csv
│  ├─ internacoes.csv
│  └─ altas.csv
└─ powerbi/
   └─ dataset_schema.json      # Esquema sugerido para importar em BI
```

---

## ⚙️ Como rodar (PostgreSQL)
1. Crie um banco local, ex.:  
   ```sql
   CREATE DATABASE hospital_bi;
   ```
2. Rode os scripts na ordem:
   - `sql/00_schema.sql`  
   - `sql/01_seed.sql`  
   - `sql/02_views.sql`  
   - `sql/03_procedures.sql`  
   - (opcional) `sql/04_reports_examples.sql`
3. Pronto: é só explorar as **views** e **funções**.  

👉 Se quiser, dá pra criar um `docker-compose.yml` com Postgres pra rodar tudo de forma mais prática (pensei em adicionar isso em uma próxima versão).

---

## 📊 KPIs que construí
- **Taxa de ocupação por dia** (internações ativas / leitos).  
- **Tempo médio de permanência (LOS)**.  
- **Reinternações em até 30 dias**.  
- **Taxa de mortalidade (mock para fins de exemplo)**.  
- **Entradas e saídas por período**.  

---

## 🧠 Decisões que tomei
- Separei **pacientes**, **internações** e **altas** para poder medir permanência e desfechos.  
- Criei uma **dimensão tempo** a partir das datas existentes (sem depender de tabela fixa de calendário).  
- Estruturei **views semânticas** (`d_paciente`, `d_tempo`, `f_internacao`) pensando em consumo por ferramentas de BI.  

---

## 🧪 Perguntas que esse modelo responde (ótimo em entrevistas)
- Como calcular a **taxa de ocupação diária**?  
- Qual a **média de permanência por ala/médico/mês**?  
- Como identificar **reinternações em até 30 dias**?  

---

## 🗂️ Licença
MIT — pode usar, modificar, aprender e até mostrar em entrevistas também.  

---

> Criado com carinho por **Tiago Dotto** — 2025-10-07  
