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

-- ============================================================
-- PROJETO LÓGICO - SISTEMA E-COMMERCE
-- Script completo: Schema + Dados de Teste + Queries
-- Compatível com MariaDB e MySQL 8.x
-- ============================================================

CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- ============================================================
-- SCHEMA — DDL
-- ============================================================

CREATE TABLE Conta (
    idConta         INT            NOT NULL AUTO_INCREMENT,
    email           VARCHAR(100)   NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    dataCadastro    DATE           NOT NULL DEFAULT '2024-01-01',
    ativo           TINYINT(1)     NOT NULL DEFAULT 1,
    tipo            ENUM('PF','PJ') NOT NULL,
    PRIMARY KEY (idConta)
);

CREATE TABLE ClientePF (
    idConta         INT          NOT NULL,
    nome            VARCHAR(100) NOT NULL,
    cpf             CHAR(11)     NOT NULL UNIQUE,
    dataNascimento  DATE,
    PRIMARY KEY (idConta),
    CONSTRAINT fk_pf_conta FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ClientePJ (
    idConta           INT          NOT NULL,
    razaoSocial       VARCHAR(150) NOT NULL,
    cnpj              CHAR(14)     NOT NULL UNIQUE,
    nomeFantasia      VARCHAR(150),
    inscricaoEstadual VARCHAR(30),
    PRIMARY KEY (idConta),
    CONSTRAINT fk_pj_conta FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Endereco (
    idEndereco  INT          NOT NULL AUTO_INCREMENT,
    idConta     INT          NOT NULL,
    logradouro  VARCHAR(150) NOT NULL,
    numero      VARCHAR(10),
    complemento VARCHAR(80),
    bairro      VARCHAR(80)  NOT NULL,
    cidade      VARCHAR(80)  NOT NULL,
    estado      CHAR(2)      NOT NULL,
    cep         CHAR(8)      NOT NULL,
    tipo        ENUM('Residencial','Comercial','Entrega','Cobrança') NOT NULL DEFAULT 'Entrega',
    principal   TINYINT(1)   NOT NULL DEFAULT 0,
    PRIMARY KEY (idEndereco),
    CONSTRAINT fk_end_conta FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FormaPagamento (
    idFormaPagamento INT          NOT NULL AUTO_INCREMENT,
    idConta          INT          NOT NULL,
    tipo             ENUM('Cartão de Crédito','Cartão de Débito','PIX','Boleto','Transferência') NOT NULL,
    apelido          VARCHAR(50),
    numeroMascarado  VARCHAR(19),
    bandeira         VARCHAR(30),
    nomeTitular      VARCHAR(100),
    validade         CHAR(7),
    chavePix         VARCHAR(150),
    tipoChavePix     ENUM('CPF','CNPJ','Email','Telefone','Aleatória'),
    ativo            TINYINT(1)   NOT NULL DEFAULT 1,
    PRIMARY KEY (idFormaPagamento),
    CONSTRAINT fk_fp_conta FOREIGN KEY (idConta) REFERENCES Conta(idConta)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Categoria (
    idCategoria    INT         NOT NULL AUTO_INCREMENT,
    nome           VARCHAR(80) NOT NULL,
    idCategoriaPai INT,
    PRIMARY KEY (idCategoria),
    CONSTRAINT fk_cat_pai FOREIGN KEY (idCategoriaPai) REFERENCES Categoria(idCategoria)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Produto (
    idProduto   INT           NOT NULL AUTO_INCREMENT,
    nome        VARCHAR(150)  NOT NULL,
    descricao   TEXT,
    preco       DECIMAL(10,2) NOT NULL,
    idCategoria INT,
    PRIMARY KEY (idProduto),
    CONSTRAINT fk_prod_cat FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Estoque (
    idEstoque         INT         NOT NULL AUTO_INCREMENT,
    idProduto         INT         NOT NULL UNIQUE,
    quantidade        INT         NOT NULL DEFAULT 0,
    localizacao       VARCHAR(80),
    ultimaAtualizacao DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                  ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (idEstoque),
    CONSTRAINT fk_est_prod FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Fornecedor (
    idFornecedor INT          NOT NULL AUTO_INCREMENT,
    razaoSocial  VARCHAR(150) NOT NULL,
    cnpj         CHAR(14)     NOT NULL UNIQUE,
    email        VARCHAR(100),
    telefone     VARCHAR(20),
    PRIMARY KEY (idFornecedor)
);

CREATE TABLE Produto_Fornecedor (
    idProduto       INT           NOT NULL,
    idFornecedor    INT           NOT NULL,
    precoFornecedor DECIMAL(10,2),
    PRIMARY KEY (idProduto, idFornecedor),
    CONSTRAINT fk_pf_prod FOREIGN KEY (idProduto)    REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pf_forn FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Vendedor (
    idVendedor  INT          NOT NULL AUTO_INCREMENT,
    razaoSocial VARCHAR(150) NOT NULL,
    cnpj        CHAR(14)     NOT NULL UNIQUE,
    nomeFantasia VARCHAR(150),
    avaliacao   DECIMAL(2,1) DEFAULT 0.0,
    PRIMARY KEY (idVendedor)
);

CREATE TABLE Produto_Vendedor (
    idProduto  INT           NOT NULL,
    idVendedor INT           NOT NULL,
    preco      DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idProduto, idVendedor),
    CONSTRAINT fk_pv_prod FOREIGN KEY (idProduto)  REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pv_vend FOREIGN KEY (idVendedor) REFERENCES Vendedor(idVendedor)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Pedido (
    idPedido          INT           NOT NULL AUTO_INCREMENT,
    idConta           INT           NOT NULL,
    idEnderecoEntrega INT           NOT NULL,
    dataPedido        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status            ENUM('Aguardando Pagamento','Pago','Em Separação','Enviado','Entregue','Cancelado','Devolvido')
                                    NOT NULL DEFAULT 'Aguardando Pagamento',
    valorTotal        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    observacao        TEXT,
    PRIMARY KEY (idPedido),
    CONSTRAINT fk_ped_conta FOREIGN KEY (idConta)           REFERENCES Conta(idConta)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ped_end   FOREIGN KEY (idEnderecoEntrega) REFERENCES Endereco(idEndereco)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Pedido_Pagamento (
    idPedido         INT           NOT NULL,
    idFormaPagamento INT           NOT NULL,
    valor            DECIMAL(10,2) NOT NULL,
    status           ENUM('Pendente','Aprovado','Recusado','Estornado') NOT NULL DEFAULT 'Pendente',
    dataTransacao    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    codigoTransacao  VARCHAR(100),
    PRIMARY KEY (idPedido, idFormaPagamento),
    CONSTRAINT fk_pp_pedido FOREIGN KEY (idPedido)         REFERENCES Pedido(idPedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pp_fp     FOREIGN KEY (idFormaPagamento) REFERENCES FormaPagamento(idFormaPagamento)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Item_Pedido (
    idItemPedido  INT           NOT NULL AUTO_INCREMENT,
    idPedido      INT           NOT NULL,
    idProduto     INT           NOT NULL,
    quantidade    INT           NOT NULL DEFAULT 1,
    valorUnitario DECIMAL(10,2) NOT NULL,
    desconto      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (idItemPedido),
    CONSTRAINT fk_ip_pedido FOREIGN KEY (idPedido)  REFERENCES Pedido(idPedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ip_prod   FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Entrega (
    idEntrega      INT         NOT NULL AUTO_INCREMENT,
    idPedido       INT         NOT NULL UNIQUE,
    codigoRastreio VARCHAR(50) NOT NULL UNIQUE,
    transportadora VARCHAR(100),
    status         ENUM('Aguardando Coleta','Coletado','Em Trânsito','Saiu para Entrega','Entregue','Tentativa de Entrega','Devolvido ao Remetente')
                               NOT NULL DEFAULT 'Aguardando Coleta',
    dataEnvio      DATETIME,
    dataPrevisao   DATE,
    dataEntrega    DATETIME,
    PRIMARY KEY (idEntrega),
    CONSTRAINT fk_ent_pedido FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Rastreio_Historico (
    idHistorico INT          NOT NULL AUTO_INCREMENT,
    idEntrega   INT          NOT NULL,
    dataEvento  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    local       VARCHAR(150),
    descricao   VARCHAR(255) NOT NULL,
    PRIMARY KEY (idHistorico),
    CONSTRAINT fk_rh_entrega FOREIGN KEY (idEntrega) REFERENCES Entrega(idEntrega)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- DADOS DE TESTE — DML
-- ============================================================

INSERT INTO Conta (email, telefone, dataCadastro, ativo, tipo) VALUES
('ana.silva@email.com',    '11999990001', '2023-01-10', 1, 'PF'),
('carlos.souza@email.com', '21988880002', '2023-03-15', 1, 'PF'),
('empresa@techprime.com',  '11333330003', '2022-06-20', 1, 'PJ'),
('contato@megastore.com',  '11444440004', '2022-09-05', 1, 'PJ'),
('joao.lima@email.com',    '31977770005', '2023-07-22', 1, 'PF'),
('maria.dias@email.com',   '85966660006', '2024-01-03', 1, 'PF');

INSERT INTO ClientePF (idConta, nome, cpf, dataNascimento) VALUES
(1, 'Ana Silva',    '11122233344', '1990-05-14'),
(2, 'Carlos Souza', '55566677788', '1985-11-30'),
(5, 'João Lima',    '99900011122', '1995-03-08'),
(6, 'Maria Dias',   '33344455566', '2000-07-19');

INSERT INTO ClientePJ (idConta, razaoSocial, cnpj, nomeFantasia) VALUES
(3, 'TechPrime Soluções LTDA',  '12345678000190', 'TechPrime'),
(4, 'Mega Store Comercio LTDA', '98765432000155', 'MegaStore');

INSERT INTO Endereco (idConta, logradouro, numero, bairro, cidade, estado, cep, tipo, principal) VALUES
(1, 'Rua das Flores',     '100', 'Centro',     'São Paulo',      'SP', '01310000', 'Residencial', 1),
(2, 'Av. Brasil',         '200', 'Copacabana', 'Rio de Janeiro', 'RJ', '22020001', 'Residencial', 1),
(3, 'Rua das Industrias', '500', 'Bairro Ind', 'São Paulo',      'SP', '04000000', 'Comercial',   1),
(4, 'Av. Paulista',       '900', 'Bela Vista', 'São Paulo',      'SP', '01310100', 'Comercial',   1),
(5, 'Rua Minas Gerais',   '300', 'Savassi',    'Belo Horizonte', 'MG', '30130000', 'Residencial', 1),
(6, 'Rua da Paz',         '50',  'Aldeota',    'Fortaleza',      'CE', '60140000', 'Residencial', 1);

INSERT INTO FormaPagamento (idConta, tipo, apelido, numeroMascarado, bandeira, nomeTitular, validade, ativo) VALUES
(1, 'Cartão de Crédito', 'Visa Ana',      '**** **** **** 1234', 'Visa',       'Ana Silva',    '12/2026', 1),
(1, 'PIX',               'PIX Ana',        NULL,                  NULL,         NULL,           NULL,      1),
(2, 'Cartão de Débito',  'Débito Carlos',  '**** **** **** 5678', 'Mastercard', 'Carlos Souza', '08/2025', 1),
(3, 'Boleto',            'Boleto Empresa', NULL,                  NULL,         NULL,           NULL,      1),
(4, 'Cartão de Crédito', 'Amex MegaStore', '**** **** **** 9012', 'Amex',      'MegaStore',    '03/2027', 1),
(5, 'PIX',               'PIX João',       NULL,                  NULL,         NULL,           NULL,      1),
(6, 'Cartão de Crédito', 'Visa Maria',     '**** **** **** 3456', 'Visa',       'Maria Dias',   '09/2026', 1),
(1, 'Cartão de Crédito', 'Master Ana',     '**** **** **** 7890', 'Mastercard', 'Ana Silva',    '06/2028', 1);

INSERT INTO Categoria (nome, idCategoriaPai) VALUES
('Eletronicos',   NULL),
('Smartphones',   1),
('Notebooks',     1),
('Perifericos',   1),
('Casa e Jardim', NULL),
('Ferramentas',   5);

INSERT INTO Produto (nome, descricao, preco, idCategoria) VALUES
('iPhone 15 Pro',      'Apple iPhone 15 Pro 256GB',           8999.00, 2),
('Samsung Galaxy S24', 'Samsung Galaxy S24 128GB',            4599.00, 2),
('MacBook Air M2',     'Apple MacBook Air chip M2 8GB 256GB', 9499.00, 3),
('Dell Inspiron 15',   'Dell Inspiron 15 i5 16GB 512GB',      4299.00, 3),
('Mouse Logitech MX',  'Mouse sem fio Logitech MX Master 3',   599.00, 4),
('Teclado Mecanico',   'Teclado mecanico RGB Redragon',         349.00, 4),
('Furadeira Bosch',    'Furadeira de Impacto Bosch 650W',       459.00, 6),
('Kit Jardim',         'Kit ferramentas para jardim 10 pecas',  189.00, 5);

INSERT INTO Estoque (idProduto, quantidade, localizacao) VALUES
(1,  50, 'Galpao A - Prateleira 1'),
(2, 120, 'Galpao A - Prateleira 2'),
(3,  30, 'Galpao B - Prateleira 1'),
(4,  80, 'Galpao B - Prateleira 2'),
(5, 200, 'Galpao C - Prateleira 1'),
(6, 150, 'Galpao C - Prateleira 2'),
(7,  40, 'Galpao D - Prateleira 1'),
(8,  90, 'Galpao D - Prateleira 2');

INSERT INTO Fornecedor (razaoSocial, cnpj, email, telefone) VALUES
('Apple Brasil LTDA',      '11111111000101', 'fornecedor@apple.com.br',   '11900000001'),
('Samsung Brasil LTDA',    '22222222000102', 'fornecedor@samsung.com.br', '11900000002'),
('Dell Computadores LTDA', '33333333000103', 'fornecedor@dell.com.br',    '11900000003'),
('Logitech Brasil LTDA',   '44444444000104', 'fornecedor@logitech.com',   '11900000004'),
('Bosch Brasil LTDA',      '55555555000105', 'fornecedor@bosch.com.br',   '11900000005');

INSERT INTO Produto_Fornecedor (idProduto, idFornecedor, precoFornecedor) VALUES
(1, 1, 7200.00),
(2, 2, 3500.00),
(3, 1, 7800.00),
(4, 3, 3200.00),
(5, 4,  380.00),
(6, 4,  200.00),
(7, 5,  300.00);

INSERT INTO Vendedor (razaoSocial, cnpj, nomeFantasia, avaliacao) VALUES
('TechVendas LTDA',      '66666666000106', 'TechVendas',    4.8),
('Bosch Brasil LTDA',    '55555555000105', 'Bosch Oficial', 4.9),
('Multi Eletronicos ME', '77777777000107', 'MultiEletro',   4.2);

INSERT INTO Produto_Vendedor (idProduto, idVendedor, preco) VALUES
(1, 1, 9199.00),
(2, 1, 4799.00),
(5, 3,  649.00),
(6, 3,  399.00),
(7, 2,  479.00);

INSERT INTO Pedido (idConta, idEnderecoEntrega, dataPedido, status, valorTotal) VALUES
(1, 1, '2024-02-10 10:30:00', 'Entregue',             9598.00),
(1, 1, '2024-03-05 14:00:00', 'Entregue',              599.00),
(2, 2, '2024-03-12 09:15:00', 'Enviado',              4599.00),
(3, 3, '2024-04-01 11:00:00', 'Em Separação',        13798.00),
(5, 5, '2024-04-10 16:45:00', 'Pago',                  349.00),
(6, 6, '2024-04-15 08:00:00', 'Aguardando Pagamento',  189.00),
(2, 2, '2024-04-20 13:30:00', 'Cancelado',            4299.00),
(4, 4, '2024-04-22 10:00:00', 'Pago',                 8999.00);

INSERT INTO Item_Pedido (idPedido, idProduto, quantidade, valorUnitario, desconto) VALUES
(1, 1, 1, 8999.00, 0.00),
(1, 5, 1,  599.00, 0.00),
(2, 5, 1,  599.00, 0.00),
(3, 2, 1, 4599.00, 0.00),
(4, 3, 1, 9499.00, 0.00),
(4, 4, 1, 4299.00, 0.00),
(5, 6, 1,  349.00, 0.00),
(6, 8, 1,  189.00, 0.00),
(7, 4, 1, 4299.00, 0.00),
(8, 1, 1, 8999.00, 0.00);

INSERT INTO Pedido_Pagamento (idPedido, idFormaPagamento, valor, status, codigoTransacao) VALUES
(1, 1, 9598.00, 'Aprovado', 'TXN001'),
(2, 2,  599.00, 'Aprovado', 'TXN002'),
(3, 3, 4599.00, 'Aprovado', 'TXN003'),
(4, 4, 8000.00, 'Aprovado', 'TXN004'),
(4, 5, 5798.00, 'Aprovado', 'TXN005'),
(5, 6,  349.00, 'Aprovado', 'TXN006'),
(6, 7,  189.00, 'Pendente', NULL),
(8, 5, 8999.00, 'Aprovado', 'TXN008');

INSERT INTO Entrega (idPedido, codigoRastreio, transportadora, status, dataEnvio, dataPrevisao, dataEntrega) VALUES
(1, 'BR001234560BR', 'Correios', 'Entregue',          '2024-02-11', '2024-02-15', '2024-02-14'),
(2, 'BR002345670BR', 'Correios', 'Entregue',          '2024-03-06', '2024-03-10', '2024-03-09'),
(3, 'JD334455667BR', 'Jadlog',   'Em Trânsito',       '2024-03-13', '2024-03-18', NULL),
(4, 'FX445566778BR', 'FedEx',    'Aguardando Coleta', NULL,         '2024-04-10', NULL),
(5, 'BR556677889BR', 'Correios', 'Saiu para Entrega', '2024-04-11', '2024-04-15', NULL);

INSERT INTO Rastreio_Historico (idEntrega, dataEvento, local, descricao) VALUES
(1, '2024-02-11 08:00:00', 'Sao Paulo, SP',      'Objeto postado'),
(1, '2024-02-12 14:00:00', 'Campinas, SP',       'Em transito para unidade de distribuicao'),
(1, '2024-02-14 10:00:00', 'Sao Paulo, SP',      'Objeto entregue ao destinatario'),
(3, '2024-03-13 09:30:00', 'Rio de Janeiro, RJ', 'Objeto postado'),
(3, '2024-03-14 16:00:00', 'Juiz de Fora, MG',   'Em transito'),
(5, '2024-04-11 07:00:00', 'Belo Horizonte, MG', 'Objeto postado'),
(5, '2024-04-14 08:30:00', 'Belo Horizonte, MG', 'Saiu para entrega');

-- ============================================================
-- QUERIES
-- ============================================================

-- Q1: Clientes PF cadastrados
SELECT c.idConta, pf.nome, pf.cpf, c.email, c.telefone, c.dataCadastro
FROM Conta c
INNER JOIN ClientePF pf ON c.idConta = pf.idConta
ORDER BY pf.nome;

-- Q2: Pedidos despachados ou entregues
SELECT idPedido, dataPedido, status, valorTotal
FROM Pedido
WHERE status IN ('Entregue', 'Enviado')
ORDER BY dataPedido DESC;

-- Q3: Valor líquido e percentual de desconto por item (atributo derivado)
SELECT
    ip.idPedido,
    pr.nome                                             AS produto,
    ip.quantidade,
    ip.valorUnitario,
    ip.desconto,
    (ip.valorUnitario * ip.quantidade)                  AS valorBruto,
    ((ip.valorUnitario - ip.desconto) * ip.quantidade)  AS valorLiquido,
    ROUND((ip.desconto / ip.valorUnitario) * 100, 2)    AS percentualDesconto
FROM Item_Pedido ip
INNER JOIN Produto pr ON ip.idProduto = pr.idProduto
ORDER BY ip.idPedido;

-- Q4: Quantidade de pedidos e ticket médio por cliente
SELECT
    c.idConta,
    COALESCE(pf.nome, pj.razaoSocial) AS nomeCliente,
    c.tipo,
    COUNT(p.idPedido)                 AS totalPedidos,
    SUM(p.valorTotal)                 AS valorTotalGasto,
    ROUND(AVG(p.valorTotal), 2)       AS ticketMedio
FROM Conta c
LEFT JOIN ClientePF pf ON c.idConta = pf.idConta
LEFT JOIN ClientePJ pj ON c.idConta = pj.idConta
LEFT JOIN Pedido p     ON c.idConta = p.idConta
GROUP BY c.idConta, nomeCliente, c.tipo
ORDER BY totalPedidos DESC, valorTotalGasto DESC;

-- Q5: Clientes recorrentes — HAVING
SELECT
    c.idConta,
    COALESCE(pf.nome, pj.razaoSocial) AS nomeCliente,
    c.tipo,
    COUNT(p.idPedido)                 AS totalPedidos
FROM Conta c
LEFT JOIN ClientePF pf ON c.idConta = pf.idConta
LEFT JOIN ClientePJ pj ON c.idConta = pj.idConta
INNER JOIN Pedido p    ON c.idConta = p.idConta
GROUP BY c.idConta, nomeCliente, c.tipo
HAVING COUNT(p.idPedido) > 1
ORDER BY totalPedidos DESC;

-- Q6: Vendedor que também é fornecedor (mesmo CNPJ)
SELECT
    v.idVendedor, v.razaoSocial AS nomeVendedor, v.nomeFantasia,
    f.idFornecedor, f.razaoSocial AS nomeFornecedor, v.cnpj
FROM Vendedor v
INNER JOIN Fornecedor f ON v.cnpj = f.cnpj;

-- Q7: Produto x Fornecedor x Estoque com margem bruta
SELECT
    pr.idProduto,
    pr.nome                                                               AS produto,
    cat.nome                                                              AS categoria,
    f.razaoSocial                                                         AS fornecedor,
    pf.precoFornecedor,
    pr.preco                                                              AS precoVenda,
    ROUND(pr.preco - pf.precoFornecedor, 2)                              AS margemBruta,
    ROUND(((pr.preco - pf.precoFornecedor) / pf.precoFornecedor)*100, 2) AS margemPerc,
    e.quantidade                                                          AS estoqueAtual,
    e.localizacao
FROM Produto pr
LEFT JOIN Categoria cat         ON pr.idCategoria  = cat.idCategoria
LEFT JOIN Produto_Fornecedor pf ON pr.idProduto    = pf.idProduto
LEFT JOIN Fornecedor f          ON pf.idFornecedor = f.idFornecedor
LEFT JOIN Estoque e             ON pr.idProduto    = e.idProduto
ORDER BY pr.idCategoria, pr.nome;

-- Q8: Nome dos fornecedores e produtos que fornecem
SELECT
    f.razaoSocial AS fornecedor,
    f.email,
    pr.nome       AS produto,
    pf.precoFornecedor
FROM Fornecedor f
INNER JOIN Produto_Fornecedor pf ON f.idFornecedor = pf.idFornecedor
INNER JOIN Produto pr            ON pf.idProduto   = pr.idProduto
ORDER BY f.razaoSocial, pr.nome;

-- Q9: Pedidos com mais de uma forma de pagamento
SELECT
    pp.idPedido,
    COUNT(pp.idFormaPagamento)                                   AS qtdFormas,
    SUM(pp.valor)                                                AS totalPago,
    GROUP_CONCAT(fp.tipo ORDER BY fp.tipo SEPARATOR ' + ')      AS formasUsadas
FROM Pedido_Pagamento pp
INNER JOIN FormaPagamento fp ON pp.idFormaPagamento = fp.idFormaPagamento
WHERE pp.status = 'Aprovado'
GROUP BY pp.idPedido
HAVING COUNT(pp.idFormaPagamento) > 1;

-- Q10: Status de entrega e rastreio por pedido com dias de entrega (atributo derivado)
SELECT
    p.idPedido,
    COALESCE(pf.nome, pj.razaoSocial) AS cliente,
    p.status                          AS statusPedido,
    e.codigoRastreio,
    e.transportadora,
    e.status                          AS statusEntrega,
    e.dataEnvio,
    e.dataPrevisao,
    e.dataEntrega,
    CASE
        WHEN e.dataEntrega IS NOT NULL
        THEN DATEDIFF(e.dataEntrega, e.dataEnvio)
        ELSE NULL
    END                               AS diasParaEntrega
FROM Pedido p
INNER JOIN Conta c     ON p.idConta  = c.idConta
LEFT JOIN ClientePF pf ON c.idConta  = pf.idConta
LEFT JOIN ClientePJ pj ON c.idConta  = pj.idConta
LEFT JOIN Entrega e    ON p.idPedido = e.idPedido
ORDER BY p.dataPedido DESC;

-- Q11: Produtos mais vendidos por receita
SELECT
    pr.idProduto,
    pr.nome                               AS produto,
    cat.nome                              AS categoria,
    SUM(ip.quantidade)                    AS totalVendido,
    SUM(ip.quantidade * ip.valorUnitario) AS receitaTotal,
    ROUND(AVG(ip.valorUnitario), 2)       AS precoMedioVendido
FROM Item_Pedido ip
INNER JOIN Produto pr    ON ip.idProduto   = pr.idProduto
INNER JOIN Pedido p      ON ip.idPedido    = p.idPedido
LEFT JOIN  Categoria cat ON pr.idCategoria = cat.idCategoria
WHERE p.status NOT IN ('Cancelado','Devolvido')
GROUP BY pr.idProduto, pr.nome, cat.nome
ORDER BY receitaTotal DESC;

-- Q12: Formas de pagamento por cliente
SELECT
    c.idConta,
    COALESCE(pf.nome, pj.razaoSocial)                         AS cliente,
    c.tipo,
    COUNT(fp.idFormaPagamento)                                AS qtdFormas,
    GROUP_CONCAT(fp.tipo ORDER BY fp.tipo SEPARATOR ', ')     AS formasCadastradas
FROM Conta c
LEFT JOIN ClientePF pf      ON c.idConta = pf.idConta
LEFT JOIN ClientePJ pj      ON c.idConta = pj.idConta
LEFT JOIN FormaPagamento fp ON c.idConta = fp.idConta AND fp.ativo = 1
GROUP BY c.idConta, cliente, c.tipo
ORDER BY qtdFormas DESC;

-- Q13: Histórico completo de rastreio do pedido 1
SELECT
    e.codigoRastreio, e.transportadora,
    rh.dataEvento, rh.local, rh.descricao, e.status AS statusAtual
FROM Entrega e
INNER JOIN Rastreio_Historico rh ON e.idEntrega = rh.idEntrega
WHERE e.idPedido = 1
ORDER BY rh.dataEvento;

-- Q14: Produtos sem fornecedor cadastrado
SELECT pr.idProduto, pr.nome, pr.preco, e.quantidade AS estoque
FROM Produto pr
LEFT JOIN Produto_Fornecedor pf ON pr.idProduto = pf.idProduto
LEFT JOIN Estoque e             ON pr.idProduto = e.idProduto
WHERE pf.idFornecedor IS NULL;

-- Q15: Categorias com receita acima de R$ 1.000 — HAVING
SELECT
    cat.nome                              AS categoria,
    COUNT(DISTINCT ip.idPedido)           AS pedidosEnvolvidos,
    SUM(ip.quantidade * ip.valorUnitario) AS receitaTotal,
    ROUND(AVG(ip.valorUnitario), 2)       AS precoMedio
FROM Item_Pedido ip
INNER JOIN Produto pr    ON ip.idProduto   = pr.idProduto
INNER JOIN Categoria cat ON pr.idCategoria = cat.idCategoria
INNER JOIN Pedido p      ON ip.idPedido    = p.idPedido
WHERE p.status NOT IN ('Cancelado','Devolvido')
GROUP BY cat.nome
HAVING SUM(ip.quantidade * ip.valorUnitario) > 1000
ORDER BY receitaTotal DESC;

-- 1. Número de empregados por departamento e localidade

CREATE OR REPLACE VIEW vw_func_dept_local AS
SELECT d.Dname AS departamento, l.Location AS localidade, COUNT(e.Ssn) AS total_empregados
FROM departament d
JOIN dept_locations l ON d.Dnumber = l.Dnumber
JOIN employee e ON d.Dnumber = e.Dno
GROUP BY d.Dname, l.Location;

-- 2. Lista de departamentos e seus gerentes
CREATE OR REPLACE VIEW vw_depto_gerentes AS
SELECT d.Dname AS departamento, e.Fname AS gerente
FROM departament d
JOIN employee e ON d.Mgr_ssn = e.Ssn;

-- 3. Projetos com maior número de empregados (Ordenação DESC)
CREATE OR REPLACE VIEW vw_projetos_mais_alocados AS
SELECT p.Pname AS projeto, COUNT(wo.Essn) AS qtd_funcionarios
FROM project p
JOIN works_on wo ON p.Pnumber = wo.Pno
GROUP BY p.Pname
ORDER BY qtd_funcionarios DESC;

-- 4. Lista de projetos, departamentos e gerentes
CREATE OR REPLACE VIEW vw_projetos_dept_gerente AS
SELECT p.Pname AS projeto, d.Dname AS departamento, e.Fname AS gerente_responsavel
FROM project p
JOIN departament d ON p.Dnum = d.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn;

-- 5. Empregados com dependentes e se são gerentes
CREATE OR REPLACE VIEW vw_empregados_dependentes_gerentes AS
SELECT DISTINCT e.Fname AS funcionario, 
       (SELECT COUNT(*) FROM dependent dep WHERE dep.Essn = e.Ssn) AS qtd_dependentes,
       CASE WHEN d.Mgr_ssn IS NOT NULL THEN 'Sim' ELSE 'Não' END AS e_gerente
FROM employee e
LEFT JOIN departament d ON e.Ssn = d.Mgr_ssn;

-- Criando usuários
CREATE USER 'gerente_rh'@'localhost' IDENTIFIED BY 'senha123';
CREATE USER 'funcionario_comum'@'localhost' IDENTIFIED BY 'senha456';

-- Atribuindo permissões
GRANT SELECT ON vw_func_dept_local TO 'gerente_rh'@'localhost';
GRANT SELECT ON vw_depto_gerentes TO 'gerente_rh'@'localhost';

-- O funcionário não tem acesso às views de gerência
GRANT SELECT ON vw_projetos_mais_alocados TO 'funcionario_comum'@'localhost';

CREATE TABLE IF NOT EXISTS Log_Contas_Excluidas (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    idConta INT,
    email VARCHAR(100),
    data_exclusao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Gatilho de Remoção: Antes de deletar a conta, salva no log
DELIMITER $$

CREATE TRIGGER tr_backup_user_before_delete
BEFORE DELETE ON Conta
FOR EACH ROW
BEGIN
    INSERT INTO Log_Contas_Excluidas (idConta, email)
    VALUES (OLD.idConta, OLD.email);
END $$

-- Gatilho de Atualização: Validação de Preço (Substituindo 'salário' pela lógica de 'preço' do e-commerce)
CREATE TRIGGER tr_validar_preco_produto
BEFORE UPDATE ON Produto
FOR EACH ROW
BEGIN
    -- Se o novo preço for 0 ou negativo, impede a atualização
    IF NEW.preco <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: O preço do produto deve ser maior que zero.';
    END IF;
END $$

DELIMITER ;