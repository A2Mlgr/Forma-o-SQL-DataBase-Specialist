# 🛒 E-Commerce — Projeto Lógico de Banco de Dados

Este repositório contém o **projeto lógico completo** de um sistema de **E-Commerce**, desenvolvido em MySQL. O script contempla:

- **Schema (DDL)** — criação de todas as tabelas, chaves primárias, estrangeiras e constraints
- **Dados de Teste (DML)** — inserções realistas para validação das queries
- **Queries SQL** — 15 consultas analíticas cobrindo todos os requisitos do desafio

O modelo aplica os três refinamentos exigidos: separação entre clientes PF e PJ, múltiplas formas de pagamento e controle de entrega com código de rastreio.

---

## Modelo Lógico — Entidades e Relacionamentos

### Diagrama de Relacionamentos (texto)

```
Conta (1) ──── (1) ClientePF          [herança exclusiva]
Conta (1) ──── (1) ClientePJ          [herança exclusiva]
Conta (1) ──── (N) Endereco
Conta (1) ──── (N) FormaPagamento
Conta (1) ──── (N) Pedido

Pedido  (N) ──── (M) FormaPagamento   [via Pedido_Pagamento]
Pedido  (1) ──── (N) Item_Pedido
Pedido  (1) ──── (1) Entrega

Item_Pedido (N) ──── (1) Produto

Produto (N) ──── (M) Fornecedor       [via Produto_Fornecedor]
Produto (N) ──── (M) Vendedor         [via Produto_Vendedor]
Produto (1) ──── (1) Estoque
Produto (N) ──── (1) Categoria

Categoria (N) ──── (1) Categoria      [auto-relacionamento]

Entrega (1) ──── (N) Rastreio_Historico
```

---

## Tabelas e Atributos

### `Conta`
Base da herança. Define se a conta é PF ou PJ.

| Coluna | Tipo | Constraint |
|---|---|---|
| idConta | INT | PK, AUTO_INCREMENT |
| email | VARCHAR(100) | NOT NULL, UNIQUE |
| telefone | VARCHAR(20) | |
| dataCadastro | DATE | NOT NULL, DEFAULT CURRENT_DATE |
| ativo | TINYINT(1) | NOT NULL, DEFAULT 1 |
| tipo | ENUM('PF','PJ') | NOT NULL |

### `ClientePF` *(especialização de Conta)*
| Coluna | Tipo | Constraint |
|---|---|---|
| idConta | INT | PK, FK → Conta |
| nome | VARCHAR(100) | NOT NULL |
| cpf | CHAR(11) | NOT NULL, UNIQUE |
| dataNascimento | DATE | |

### `ClientePJ` *(especialização de Conta)*
| Coluna | Tipo | Constraint |
|---|---|---|
| idConta | INT | PK, FK → Conta |
| razaoSocial | VARCHAR(150) | NOT NULL |
| cnpj | CHAR(14) | NOT NULL, UNIQUE |
| nomeFantasia | VARCHAR(150) | |
| inscricaoEstadual | VARCHAR(30) | |

### `Endereco`
| Coluna | Tipo | Constraint |
|---|---|---|
| idEndereco | INT | PK |
| idConta | INT | FK → Conta |
| logradouro | VARCHAR(150) | NOT NULL |
| numero | VARCHAR(10) | |
| complemento | VARCHAR(80) | |
| bairro | VARCHAR(80) | NOT NULL |
| cidade | VARCHAR(80) | NOT NULL |
| estado | CHAR(2) | NOT NULL |
| cep | CHAR(8) | NOT NULL |
| tipo | ENUM | NOT NULL |
| principal | TINYINT(1) | NOT NULL |

### `FormaPagamento`
Permite múltiplas formas por conta. Campos específicos por tipo (cartão, PIX, etc.).

| Coluna | Tipo | Constraint |
|---|---|---|
| idFormaPagamento | INT | PK |
| idConta | INT | FK → Conta |
| tipo | ENUM | NOT NULL |
| apelido | VARCHAR(50) | |
| numeroMascarado | VARCHAR(19) | |
| bandeira | VARCHAR(30) | |
| nomeTitular | VARCHAR(100) | |
| validade | CHAR(7) | |
| chavePix | VARCHAR(150) | |
| tipoChavePix | ENUM | |
| ativo | TINYINT(1) | NOT NULL |

### `Categoria`
Auto-relacionamento para hierarquia de categorias.

### `Produto`
| Coluna | Tipo | Constraint |
|---|---|---|
| idProduto | INT | PK |
| nome | VARCHAR(150) | NOT NULL |
| descricao | TEXT | |
| preco | DECIMAL(10,2) | NOT NULL |
| idCategoria | INT | FK → Categoria |

### `Estoque`
Relação 1:1 com Produto.

### `Fornecedor` / `Vendedor`
Entidades independentes, podendo ter CNPJ em comum (caso real de marketplace).

### `Pedido`
| Coluna | Tipo | Constraint |
|---|---|---|
| idPedido | INT | PK |
| idConta | INT | FK → Conta |
| idEnderecoEntrega | INT | FK → Endereco |
| dataPedido | DATETIME | NOT NULL |
| status | ENUM(7 estados) | NOT NULL |
| valorTotal | DECIMAL(10,2) | NOT NULL |

### `Pedido_Pagamento` *(N:M — múltiplos pagamentos por pedido)*
| Coluna | Tipo | Constraint |
|---|---|---|
| idPedido | INT | PK, FK → Pedido |
| idFormaPagamento | INT | PK, FK → FormaPagamento |
| valor | DECIMAL(10,2) | NOT NULL |
| status | ENUM(4 estados) | NOT NULL |
| dataTransacao | DATETIME | NOT NULL |
| codigoTransacao | VARCHAR(100) | |

### `Item_Pedido`
Captura `valorUnitario` no momento da compra para preservar histórico.

### `Entrega`
| Coluna | Tipo | Constraint |
|---|---|---|
| idEntrega | INT | PK |
| idPedido | INT | FK → Pedido, UNIQUE |
| codigoRastreio | VARCHAR(50) | NOT NULL, UNIQUE |
| transportadora | VARCHAR(100) | |
| status | ENUM(7 estados) | NOT NULL |
| dataEnvio | DATETIME | |
| dataPrevisao | DATE | |
| dataEntrega | DATETIME | |

### `Rastreio_Historico`
Registra cada evento do trajeto da entrega.

---

## Queries SQL — Perguntas e Respostas

| # | Pergunta respondida | Cláusulas usadas |
|---|---|---|
| Q1 | Quais são os clientes pessoa física cadastrados? | SELECT, INNER JOIN, ORDER BY |
| Q2 | Quais pedidos já foram despachados ou entregues? | SELECT, WHERE IN, ORDER BY |
| Q3 | Qual o valor líquido de cada item com desconto? | SELECT, atributo derivado (cálculo), ORDER BY |
| Q4 | Quantos pedidos foram feitos por cada cliente? | SELECT, LEFT JOIN, GROUP BY, ORDER BY |
| Q5 | Quais clientes são recorrentes (mais de 1 pedido)? | SELECT, GROUP BY, HAVING, ORDER BY |
| Q6 | Algum vendedor também é fornecedor? | SELECT, INNER JOIN por CNPJ |
| Q7 | Qual o estoque e margem de cada produto por fornecedor? | SELECT, múltiplos JOINs, atributo derivado |
| Q8 | Quais produtos cada fornecedor abastece? | SELECT, INNER JOIN, ORDER BY |
| Q9 | Quais pedidos foram pagos com mais de uma forma? | SELECT, GROUP BY, HAVING, GROUP_CONCAT |
| Q10 | Qual o status de entrega de cada pedido? | SELECT, múltiplos JOINs, CASE WHEN |
| Q11 | Quais produtos geraram mais receita? | SELECT, SUM, GROUP BY, ORDER BY |
| Q12 | Quantas formas de pagamento cada cliente possui? | SELECT, COUNT, GROUP_CONCAT, ORDER BY |
| Q13 | Qual o trajeto completo de rastreio de um pedido? | SELECT, INNER JOIN, WHERE, ORDER BY |
| Q14 | Existem produtos sem fornecedor associado? | SELECT, LEFT JOIN, WHERE IS NULL |
| Q15 | Quais categorias geraram mais de R$1.000 em vendas? | SELECT, GROUP BY, HAVING, ORDER BY |

---

##  Decisões de Modelagem

### 1. Cliente PF e PJ — herança por tabelas separadas
Padrão *Table Per Type (TPT)*: `Conta` centraliza dados comuns; `ClientePF` e `ClientePJ` estendem com seus atributos exclusivos usando `idConta` como PK e FK simultaneamente. A exclusividade é garantida: inserir em uma tabela bloqueia a outra pela unicidade do `idConta`.

### 2. Múltiplos pagamentos por pedido
Dois níveis independentes:
- `FormaPagamento` → formas salvas na conta (N por conta)
- `Pedido_Pagamento` → N:M, permite dividir o pagamento de um pedido entre várias formas, cada uma com valor e status próprios

### 3. Entrega com status e rastreio
`Entrega` tem `codigoRastreio` único e 7 estados no ENUM. `Rastreio_Historico` guarda cada evento do trajeto, permitindo exibir a linha do tempo completa ao cliente.

### 4. `valorUnitario` em `Item_Pedido`
Preço capturado no momento da venda — imune a reajustes futuros no produto.

### 5. Vendedor pode ser Fornecedor
O campo `cnpj` é a chave de junção na Q6, revelando casos reais de marketplace onde o fabricante também vende diretamente.

### 6. Categoria com auto-relacionamento
Suporta hierarquia de N níveis (ex: Eletrônicos → Smartphones → Android).

---

## 🚀 Como usar

```bash
# 1. Acesse o MySQL Workbench ou MySQL CLI
mysql -u root -p

# 2. Execute o script completo
source /caminho/para/ecommerce_logico.sql

# 3. Verifique as tabelas criadas
USE ecommerce;
SHOW TABLES;

# 4. Execute as queries individualmente ou todas de uma vez
```

---
