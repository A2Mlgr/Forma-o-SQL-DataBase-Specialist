# 🔧 Oficina Mecânica — Projeto Lógico de Banco de Dados

## 📌 Descrição do Projeto

Este repositório contém o **projeto lógico completo** de um sistema de controle e gerenciamento de **Ordens de Serviço (OS)** para uma oficina mecânica, desenvolvido em MySQL/MariaDB.

O script contempla:
- **Schema (DDL)** — criação de todas as tabelas com PKs, FKs e constraints
- **Dados de Teste (DML)** — inserções realistas para validação das queries
- **15 Queries SQL** — consultas analíticas cobrindo todos os requisitos do desafio

---

## 🧩 Modelo Lógico — Entidades e Relacionamentos

```
Cliente      1 ──< N     Veiculo
Veiculo      1 ──< N     OrdemServico
Equipe       1 ──< N     Mecanico
Equipe       1 ──< N     OrdemServico
OrdemServico 1 ──< N     Autorizacao
OrdemServico N ──< M     Servico          (via OS_Servico)
OrdemServico N ──< M     Peca             (via OS_Peca)
Servico      N ──   1    TabelaMaoDeObra
```

---

## 🗂️ Tabelas e Atributos

| Tabela | Atributos principais | Constraints |
|---|---|---|
| **Cliente** | idCliente, nome, cpf_cnpj, telefone, email, endereco, tipo (PF/PJ) | PK, UNIQUE(cpf_cnpj) |
| **Veiculo** | idVeiculo, placa, marca, modelo, ano, cor | PK, UNIQUE(placa), FK→Cliente |
| **Equipe** | idEquipe, nome | PK |
| **Mecanico** | idMecanico, codigo, nome, endereco, especialidade | PK, UNIQUE(codigo), FK→Equipe |
| **TabelaMaoDeObra** | idMaoDeObra, descricao, valorReferencia | PK |
| **Servico** | idServico, descricao | PK, FK→TabelaMaoDeObra |
| **Peca** | idPeca, codigo, descricao, valorUnitario, estoque | PK, UNIQUE(codigo) |
| **OrdemServico** | idOS, numero, dataEmissao, dataConclusao, status, valorTotal | PK, UNIQUE(numero), FK→Veiculo, FK→Equipe |
| **Autorizacao** | idAutorizacao, dataAutorizacao, autorizado | PK, FK→OrdemServico, FK→Cliente |
| **OS_Servico** | idOS, idServico, quantidade, valorUnitario | PK composta, FK→OS, FK→Servico |
| **OS_Peca** | idOS, idPeca, quantidade, valorUnitario | PK composta, FK→OS, FK→Peca |

---

## 📋 Queries — Perguntas e Cláusulas

| # | Pergunta respondida | Cláusulas |
|---|---|---|
| Q1 | Quais mecânicos a oficina possui e suas especialidades? | SELECT, LEFT JOIN, ORDER BY |
| Q2 | Quais OS foram concluídas? | SELECT, WHERE, INNER JOIN, ORDER BY |
| Q3 | Quantos dias cada OS levou para ser concluída? | SELECT, atributo derivado (DATEDIFF), WHERE, ORDER BY |
| Q4 | Quantas OS cada cliente gerou e quanto gastou? | SELECT, LEFT JOIN, GROUP BY, ORDER BY |
| Q5 | Quais equipes faturaram mais de R$500 em OS concluídas? | SELECT, WHERE, GROUP BY, **HAVING**, ORDER BY |
| Q6 | Qual o detalhamento de custo da OS-2024-008? | SELECT, INNER JOIN, WHERE, **UNION ALL** |
| Q7 | Qual o custo de mão de obra vs peças em cada OS? | SELECT, subqueries, atributo derivado (%), LEFT JOIN |
| Q8 | Quais veículos de empresas têm OS pendentes? | SELECT, WHERE múltiplo, INNER JOIN, ORDER BY |
| Q9 | Quais peças foram mais consumidas? | SELECT, LEFT JOIN, GROUP BY, **CASE WHEN**, ORDER BY |
| Q10 | Qual equipe tem mais mecânicos e atende mais OS? | SELECT, LEFT JOIN, GROUP BY, GROUP_CONCAT, ORDER BY |
| Q11 | Quais clientes têm mais de 1 veículo? | SELECT, INNER JOIN, GROUP BY, **HAVING**, ORDER BY |
| Q12 | Quais serviços são mais frequentes e rentáveis? | SELECT, INNER JOIN, LEFT JOIN, GROUP BY, atributo derivado |
| Q13 | Qual o histórico de manutenções de um veículo? | SELECT, INNER JOIN, WHERE, ORDER BY |
| Q14 | Quais OS aguardam aprovação do cliente? | SELECT, LEFT JOIN, WHERE com OR, ORDER BY |
| Q15 | Qual o faturamento mensal da oficina em 2024? | SELECT, **DATE_FORMAT** (atributo derivado), GROUP BY, **HAVING**, ORDER BY |

---

## 💡 Decisões de Modelagem

### 1. `valorUnitario` em `OS_Servico` e `OS_Peca`
O valor cobrado no momento da OS é registrado nas tabelas associativas, preservando o histórico mesmo que a tabela de referência seja atualizada futuramente.

### 2. `Autorizacao` como entidade separada
Permite rastrear data, hora e resultado (autorizado ou não) de cada decisão do cliente, mantendo auditoria completa.

### 3. `TabelaMaoDeObra` separada de `Servico`
A tabela de referência contém o valor padrão de mercado; o `Servico` pode ter desvios desse valor (desconto, promoção), visíveis na Q12.

### 4. `estoque` em `Peca` com alerta (Q9)
Atributo derivado via `CASE WHEN` classifica o estoque em CRITICO / BAIXO / OK, sem necessidade de tabela extra.

### 5. Status da OS com 5 estados
`Aguardando Autorizacao → Autorizada → Em Execucao → Concluida / Cancelada`, refletindo o fluxo real da oficina.

### 6. `tipo` no Cliente (PF/PJ)
Permite filtrar clientes pessoa física e jurídica (ex.: frotas) para relatórios diferenciados (Q8).

---

## 🚀 Como usar no DBeaver

1. Abra o **DBeaver** e conecte ao seu banco (MariaDB ou MySQL)
2. Clique em **File → Open File** e selecione `oficina_logico.sql`
3. Pressione **Ctrl+Alt+Enter** para executar o script completo
4. Ou selecione trechos e use **Ctrl+Enter** para executar por partes

---

## 🛠️ Tecnologias

- MariaDB / MySQL 8.x
- DBeaver

---

*Desafio de Projeto — Projeto Lógico de Banco de Dados — Oficina Mecânica*