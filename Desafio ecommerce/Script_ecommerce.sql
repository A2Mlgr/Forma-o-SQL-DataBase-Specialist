-- ============================================================
-- ESQUEMA CONCEITUAL - SISTEMA DE E-COMMERCE (REFINADO)
-- ============================================================

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- ============================================================
-- TABELA: Conta (base para PF e PJ)
-- ============================================================
CREATE TABLE Conta (
    idConta         INT          NOT NULL AUTO_INCREMENT,
    email           VARCHAR(100) NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    dataCadastro    DATE         NOT NULL DEFAULT (CURRENT_DATE),
    ativo           TINYINT(1)   NOT NULL DEFAULT 1,
    tipo            ENUM('PF','PJ') NOT NULL,
    PRIMARY KEY (idConta)
);

-- ============================================================
-- TABELA: ClientePF  (herança de Conta — exclusivo para PF)
-- ============================================================
CREATE TABLE ClientePF (
    idConta         INT          NOT NULL,
    nome            VARCHAR(100) NOT NULL,
    cpf             CHAR(11)     NOT NULL UNIQUE,
    dataNascimento  DATE,
    PRIMARY KEY (idConta),
    CONSTRAINT fk_pf_conta
        FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: ClientePJ  (herança de Conta — exclusivo para PJ)
-- ============================================================
CREATE TABLE ClientePJ (
    idConta         INT          NOT NULL,
    razaoSocial     VARCHAR(150) NOT NULL,
    cnpj            CHAR(14)     NOT NULL UNIQUE,
    nomeFantasia    VARCHAR(150),
    inscricaoEstadual VARCHAR(30),
    PRIMARY KEY (idConta),
    CONSTRAINT fk_pj_conta
        FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Endereco
-- ============================================================
CREATE TABLE Endereco (
    idEndereco      INT          NOT NULL AUTO_INCREMENT,
    idConta         INT          NOT NULL,
    logradouro      VARCHAR(150) NOT NULL,
    numero          VARCHAR(10),
    complemento     VARCHAR(80),
    bairro          VARCHAR(80)  NOT NULL,
    cidade          VARCHAR(80)  NOT NULL,
    estado          CHAR(2)      NOT NULL,
    cep             CHAR(8)      NOT NULL,
    tipo            ENUM('Residencial','Comercial','Entrega','Cobrança') NOT NULL DEFAULT 'Entrega',
    principal       TINYINT(1)   NOT NULL DEFAULT 0,
    PRIMARY KEY (idEndereco),
    CONSTRAINT fk_end_conta
        FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: FormaPagamento
-- ============================================================
CREATE TABLE FormaPagamento (
    idFormaPagamento INT         NOT NULL AUTO_INCREMENT,
    idConta         INT          NOT NULL,
    tipo            ENUM('Cartão de Crédito','Cartão de Débito','PIX','Boleto','Transferência') NOT NULL,
    apelido         VARCHAR(50),
    -- Cartão
    numeroMascarado VARCHAR(19),          -- ex: **** **** **** 1234
    bandeira        VARCHAR(30),          -- Visa, Master, etc.
    nomeTitular     VARCHAR(100),
    validade        CHAR(7),              -- MM/AAAA
    -- PIX
    chavePix        VARCHAR(150),
    tipoChavePix    ENUM('CPF','CNPJ','Email','Telefone','Aleatória'),
    -- Boleto
    -- (boleto é gerado por pedido, sem dados fixos)
    ativo           TINYINT(1)   NOT NULL DEFAULT 1,
    PRIMARY KEY (idFormaPagamento),
    CONSTRAINT fk_fp_conta
        FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Categoria
-- ============================================================
CREATE TABLE Categoria (
    idCategoria     INT          NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(80)  NOT NULL,
    idCategoriaPai  INT,
    PRIMARY KEY (idCategoria),
    CONSTRAINT fk_cat_pai
        FOREIGN KEY (idCategoriaPai) REFERENCES Categoria(idCategoria)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Produto
-- ============================================================
CREATE TABLE Produto (
    idProduto       INT          NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150) NOT NULL,
    descricao       TEXT,
    preco           DECIMAL(10,2) NOT NULL,
    idCategoria     INT,
    PRIMARY KEY (idProduto),
    CONSTRAINT fk_prod_cat
        FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Estoque
-- ============================================================
CREATE TABLE Estoque (
    idEstoque       INT          NOT NULL AUTO_INCREMENT,
    idProduto       INT          NOT NULL UNIQUE,
    quantidade      INT          NOT NULL DEFAULT 0,
    localizacao     VARCHAR(80),
    ultimaAtualizacao DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP
                                 ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idEstoque),
    CONSTRAINT fk_est_prod
        FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Fornecedor
-- ============================================================
CREATE TABLE Fornecedor (
    idFornecedor    INT          NOT NULL AUTO_INCREMENT,
    razaoSocial     VARCHAR(150) NOT NULL,
    cnpj            CHAR(14)     NOT NULL UNIQUE,
    email           VARCHAR(100),
    telefone        VARCHAR(20),
    PRIMARY KEY (idFornecedor)
);

-- ============================================================
-- TABELA: Produto_Fornecedor  (N:M)
-- ============================================================
CREATE TABLE Produto_Fornecedor (
    idProduto       INT          NOT NULL,
    idFornecedor    INT          NOT NULL,
    precoFornecedor DECIMAL(10,2),
    PRIMARY KEY (idProduto, idFornecedor),
    CONSTRAINT fk_pf_prod
        FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pf_forn
        FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Vendedor (marketplace — terceiros que vendem na plataforma)
-- ============================================================
CREATE TABLE Vendedor (
    idVendedor      INT          NOT NULL AUTO_INCREMENT,
    razaoSocial     VARCHAR(150) NOT NULL,
    cnpj            CHAR(14)     NOT NULL UNIQUE,
    nomeFantasia    VARCHAR(150),
    avaliacao       DECIMAL(2,1) DEFAULT 0.0,
    PRIMARY KEY (idVendedor)
);

-- ============================================================
-- TABELA: Produto_Vendedor  (N:M — vendedor oferece produto)
-- ============================================================
CREATE TABLE Produto_Vendedor (
    idProduto       INT          NOT NULL,
    idVendedor      INT          NOT NULL,
    preco           DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduto, idVendedor),
    CONSTRAINT fk_pv_prod
        FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pv_vend
        FOREIGN KEY (idVendedor) REFERENCES Vendedor(idVendedor)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Pedido
-- ============================================================
CREATE TABLE Pedido (
    idPedido        INT          NOT NULL AUTO_INCREMENT,
    idConta         INT          NOT NULL,
    idEnderecoEntrega INT        NOT NULL,
    dataPedido      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          ENUM('Aguardando Pagamento','Pago','Em Separação','Enviado','Entregue','Cancelado','Devolvido')
                                 NOT NULL DEFAULT 'Aguardando Pagamento',
    valorTotal      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    observacao      TEXT,
    PRIMARY KEY (idPedido),
    CONSTRAINT fk_ped_conta
        FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ped_end
        FOREIGN KEY (idEnderecoEntrega) REFERENCES Endereco(idEndereco)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Pedido_Pagamento  (um pedido pode ter mais de uma forma)
-- ============================================================
CREATE TABLE Pedido_Pagamento (
    idPedido        INT          NOT NULL,
    idFormaPagamento INT         NOT NULL,
    valor           DECIMAL(10,2) NOT NULL,
    status          ENUM('Pendente','Aprovado','Recusado','Estornado') NOT NULL DEFAULT 'Pendente',
    dataTransacao   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    codigoTransacao VARCHAR(100),
    PRIMARY KEY (idPedido, idFormaPagamento),
    CONSTRAINT fk_pp_pedido
        FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pp_fp
        FOREIGN KEY (idFormaPagamento) REFERENCES FormaPagamento(idFormaPagamento)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Item_Pedido
-- ============================================================
CREATE TABLE Item_Pedido (
    idItemPedido    INT          NOT NULL AUTO_INCREMENT,
    idPedido        INT          NOT NULL,
    idProduto       INT          NOT NULL,
    quantidade      INT          NOT NULL DEFAULT 1,
    valorUnitario   DECIMAL(10,2) NOT NULL,
    desconto        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (idItemPedido),
    CONSTRAINT fk_ip_pedido
        FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ip_prod
        FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Entrega
-- ============================================================
CREATE TABLE Entrega (
    idEntrega       INT          NOT NULL AUTO_INCREMENT,
    idPedido        INT          NOT NULL UNIQUE,
    codigoRastreio  VARCHAR(50)  NOT NULL UNIQUE,
    transportadora  VARCHAR(100),
    status          ENUM('Aguardando Coleta','Coletado','Em Trânsito','Saiu para Entrega','Entregue','Tentativa de Entrega','Devolvido ao Remetente')
                                 NOT NULL DEFAULT 'Aguardando Coleta',
    dataEnvio       DATETIME,
    dataPrevisao    DATE,
    dataEntrega     DATETIME,
    PRIMARY KEY (idEntrega),
    CONSTRAINT fk_ent_pedido
        FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Rastreio_Historico  (histórico de eventos de rastreio)
-- ============================================================
CREATE TABLE Rastreio_Historico (
    idHistorico     INT          NOT NULL AUTO_INCREMENT,
    idEntrega       INT          NOT NULL,
    dataEvento      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    local           VARCHAR(150),
    descricao       VARCHAR(255) NOT NULL,
    PRIMARY KEY (idHistorico),
    CONSTRAINT fk_rh_entrega
        FOREIGN KEY (idEntrega) REFERENCES Entrega(idEntrega)
        ON DELETE CASCADE ON UPDATE CASCADE
);