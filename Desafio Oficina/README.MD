# 🔧 Oficina Mecânica — Esquema Conceitual


Este repositório contém o **esquema conceitual** de um sistema de controle e gerenciamento de **Ordens de Serviço (OS)** para uma oficina mecânica, modelado no MySQL Workbench.

O modelo foi desenvolvido a partir da narrativa fornecida como desafio de projeto, com decisões de modelagem complementares devidamente justificadas abaixo.

---

##  Contexto do Negócio

- Clientes levam veículos à oficina para conserto ou revisão periódica.
- Cada veículo é atribuído a uma **equipe de mecânicos**.
- A equipe identifica os serviços necessários e abre uma **Ordem de Serviço (OS)** com data de entrega.
- O valor da OS é composto pelo **custo de mão de obra** (consultado em tabela de referência) e pelo **valor das peças** utilizadas.
- O **cliente autoriza** a execução dos serviços antes do início.
- A **mesma equipe** avalia e executa os serviços.

---

## 🧩 Entidades e Atributos

| Entidade | Atributos principais |
|---|---|
| **Cliente** | idCliente, nome, cpf_cnpj, telefone, email, endereco, tipo (PF/PJ) |
| **Veiculo** | idVeiculo, placa, marca, modelo, ano, cor |
| **Equipe** | idEquipe, nome |
| **Mecanico** | idMecanico, codigo, nome, endereco, especialidade |
| **OrdemServico** | idOS, numero, dataEmissao, dataConclusao, status, valorTotal, observacao |
| **Autorizacao** | idAutorizacao, dataAutorizacao, autorizado |
| **TabelaMaoDeObra** | idMaoDeObra, descricao, valorReferencia |
| **Servico** | idServico, descricao |
| **Peca** | idPeca, codigo, descricao, valorUnitario, estoque |
| **OS_Servico** *(associativa)* | idOS, idServico, quantidade, valorUnitario |
| **OS_Peca** *(associativa)* | idOS, idPeca, quantidade, valorUnitario |

---

## Relacionamentos

```
Cliente     1 ──< N     Veiculo
Veiculo     1 ──< N     OrdemServico
Equipe      1 ──< N     Mecanico
Equipe      1 ──< N     OrdemServico
OrdemServico 1 ──< N    Autorizacao
OrdemServico N ──< M    Servico      (via OS_Servico)
OrdemServico N ──< M    Peca         (via OS_Peca)
Servico      N ──   1   TabelaMaoDeObra
```

---

##  Decisões de Modelagem

### 1. Entidade `Cliente` com campo `tipo` (PF / PJ)
A narrativa menciona apenas "clientes", sem especificar se são pessoas físicas ou jurídicas. Como oficinas mecânicas atendem tanto pessoas físicas quanto empresas (frotas), foi adicionado o campo `tipo` com `cpf_cnpj` unificado para suportar ambos os casos.

### 2. Entidade `Autorizacao` separada
A narrativa diz que "o cliente autoriza a execução dos serviços". Optou-se por modelar isso como uma entidade separada para registrar **data e hora da autorização** e manter rastreabilidade do histórico de aprovações, inclusive casos de recusa.

### 3. Tabela associativa `OS_Servico` com `valorUnitario`
O valor de cada serviço pode variar por OS (desconto, negociação). Por isso, o `valorUnitario` é armazenado na tabela associativa, não apenas na `TabelaMaoDeObra`.

### 4. Tabela associativa `OS_Peca` com `valorUnitario`
Da mesma forma, o preço das peças pode sofrer variação no momento da OS (reajuste de estoque, promoção). O valor é capturado no momento da emissão da OS.

### 5. Atributo `estoque` em `Peca`
Não mencionado na narrativa, mas essencial para uma oficina controlar a disponibilidade de peças e evitar OS com peças indisponíveis.

### 6. `status` da OS com 5 estados
A narrativa menciona apenas "status" sem defini-lo. Foram modelados os seguintes estados do ciclo de vida:
- `Aguardando Autorização`
- `Autorizada`
- `Em Execução`
- `Concluída`
- `Cancelada`

### 7. `valorTotal` calculado e armazenado na OS
Calculado a partir da soma de `OS_Servico` e `OS_Peca`, mas armazenado na tabela `OrdemServico` para desempenho em consultas e registro histórico mesmo que preços de referência mudem futuramente.

---
