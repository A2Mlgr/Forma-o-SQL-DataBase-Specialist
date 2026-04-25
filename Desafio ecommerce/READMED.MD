# 🛒 E-Commerce — Esquema Conceitual Refinado


Este repositório contém o **esquema conceitual refinado** de um sistema de **E-Commerce**, modelado para MySQL Workbench.

O modelo incorpora os três refinamentos solicitados — separação entre clientes PF e PJ, múltiplas formas de pagamento e controle de entrega com rastreio — além de decisões de modelagem complementares devidamente justificadas abaixo.

---

## Contexto do Negócio

- Clientes (PF ou PJ) criam contas, cadastram endereços e formas de pagamento.
- Produtos são organizados em categorias e associados a fornecedores ou vendedores terceiros (marketplace).
- Pedidos são realizados por clientes, podendo ser pagos com mais de uma forma de pagamento.
- Cada pedido gera uma entrega com código de rastreio e histórico de eventos.

---

##  Entidades e Atributos

| Entidade | Atributos principais |
|---|---|
| **Conta** | idConta, email, telefone, dataCadastro, ativo, tipo (PF/PJ) |
| **ClientePF** | idConta *(FK)*, nome, cpf, dataNascimento |
| **ClientePJ** | idConta *(FK)*, razaoSocial, cnpj, nomeFantasia, inscricaoEstadual |
| **Endereco** | idEndereco, logradouro, numero, complemento, bairro, cidade, estado, cep, tipo, principal |
| **FormaPagamento** | idFormaPagamento, tipo, apelido, numeroMascarado, bandeira, nomeTitular, validade, chavePix, tipoChavePix, ativo |
| **Categoria** | idCategoria, nome, idCategoriaPai *(auto-ref.)* |
| **Produto** | idProduto, nome, descricao, preco, idCategoria |
| **Estoque** | idEstoque, idProduto, quantidade, localizacao, ultimaAtualizacao |
| **Fornecedor** | idFornecedor, razaoSocial, cnpj, email, telefone |
| **Vendedor** | idVendedor, razaoSocial, cnpj, nomeFantasia, avaliacao |
| **Pedido** | idPedido, dataPedido, status, valorTotal, observacao |
| **Item_Pedido** | idItemPedido, quantidade, valorUnitario, desconto |
| **Pedido_Pagamento** *(associativa)* | idPedido, idFormaPagamento, valor, status, dataTransacao, codigoTransacao |
| **Entrega** | idEntrega, codigoRastreio, transportadora, status, dataEnvio, dataPrevisao, dataEntrega |
| **Rastreio_Historico** | idHistorico, dataEvento, local, descricao |

---

##  Relacionamentos

```
Conta        1 ──  1     ClientePF          (exclusivo — herança)
Conta        1 ──  1     ClientePJ          (exclusivo — herança)
Conta        1 ──< N     Endereco
Conta        1 ──< N     FormaPagamento
Conta        1 ──< N     Pedido

Pedido       N ──< M     FormaPagamento     (via Pedido_Pagamento)
Pedido       1 ──< N     Item_Pedido
Pedido       1 ──  1     Entrega

Item_Pedido  N ──   1    Produto

Produto      N ──< M     Fornecedor         (via Produto_Fornecedor)
Produto      N ──< M     Vendedor           (via Produto_Vendedor)
Produto      1 ──  1     Estoque
Produto      N ──   1    Categoria

Categoria    N ──   1    Categoria          (auto-relacionamento — subcategorias)

Entrega      1 ──< N     Rastreio_Historico
```

---

##  Decisões de Modelagem

### 1.  Cliente PF e PJ — herança com tabelas separadas
A narrativa exige que uma conta seja **PF ou PJ, nunca os dois**. Foi utilizado o padrão de **herança por tabelas especializadas**:
- `Conta` contém os dados compartilhados e o campo `tipo` (PF/PJ).
- `ClientePF` e `ClientePJ` estendem `Conta` com `idConta` como PK e FK ao mesmo tempo.
- A restrição é garantida em nível de aplicação: ao criar uma conta PF, insere-se em `ClientePF`; PJ em `ClientePJ`. Nunca nos dois.
- Essa abordagem mantém integridade referencial e evita campos nulos em excesso (alternativa: tabela única com muitos NULL).

### 2.  Pagamento — múltiplas formas por conta e por pedido
Dois níveis foram modelados:
- **`FormaPagamento`** — formas cadastradas na conta do cliente (cartão salvo, chave PIX, etc.), podendo ter N formas.
- **`Pedido_Pagamento`** — associação N:M entre pedido e forma de pagamento, permitindo que **um pedido seja pago com mais de uma forma** (ex: parte no crédito, parte no PIX), cada um com seu `valor` e `status` de transação independentes.

### 3.  Entrega — status e código de rastreio
A entidade `Entrega` possui:
- `codigoRastreio` — único por entrega.
- `status` — 7 estados do ciclo de vida da entrega.
- `Rastreio_Historico` — tabela filha que registra **cada evento** de rastreio com data, local e descrição, permitindo exibir o histórico completo ao cliente.

### 4. Categoria com auto-relacionamento
Categorias podem ter subcategorias (ex: Eletrônicos → Smartphones → Android). O auto-relacionamento via `idCategoriaPai` suporta hierarquia de N níveis.

### 5. Separação entre Fornecedor e Vendedor
- **Fornecedor** — empresa que abastece o estoque da plataforma (B2B).
- **Vendedor** — terceiro que vende diretamente ao cliente via marketplace (B2C), com avaliação própria e preço independente por produto.

### 6. Estoque separado de Produto
O estoque é modelado em tabela própria para facilitar operações de entrada/saída e auditoria, sem poluir a entidade `Produto`.

### 7. `valorUnitario` em `Item_Pedido`
O preço do produto no momento da compra é capturado no item do pedido, garantindo que alterações futuras no preço do produto não afetem pedidos históricos.

### 8. Múltiplos endereços por conta
Um cliente pode ter endereços de tipos distintos (residencial, entrega, cobrança), com flag `principal` para o endereço padrão.

---
