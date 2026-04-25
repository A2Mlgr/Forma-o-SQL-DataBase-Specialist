-- ============================================================
-- ESQUEMA CONCEITUAL - SISTEMA DE OFICINA MECÂNICA
-- ============================================================

CREATE DATABASE IF NOT EXISTS oficina_mecanica;
USE oficina_mecanica;

-- ============================================================
-- TABELA: Cliente
-- ============================================================
CREATE TABLE Cliente (
    idCliente       INT          NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(100) NOT NULL,
    cpf_cnpj        VARCHAR(18)  NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    email           VARCHAR(100),
    endereco        VARCHAR(255),
    tipo            ENUM('PF','PJ') NOT NULL DEFAULT 'PF',
    PRIMARY KEY (idCliente)
);

-- ============================================================
-- TABELA: Veiculo
-- ============================================================
CREATE TABLE Veiculo (
    idVeiculo       INT          NOT NULL AUTO_INCREMENT,
    placa           VARCHAR(10)  NOT NULL UNIQUE,
    marca           VARCHAR(50)  NOT NULL,
    modelo          VARCHAR(50)  NOT NULL,
    ano             YEAR         NOT NULL,
    cor             VARCHAR(30),
    idCliente       INT          NOT NULL,
    PRIMARY KEY (idVeiculo),
    CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Equipe
-- ============================================================
CREATE TABLE Equipe (
    idEquipe        INT          NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(80)  NOT NULL,
    PRIMARY KEY (idEquipe)
);

-- ============================================================
-- TABELA: Mecanico
-- ============================================================
CREATE TABLE Mecanico (
    idMecanico      INT          NOT NULL AUTO_INCREMENT,
    codigo          VARCHAR(20)  NOT NULL UNIQUE,
    nome            VARCHAR(100) NOT NULL,
    endereco        VARCHAR(255),
    especialidade   VARCHAR(80)  NOT NULL,
    idEquipe        INT,
    PRIMARY KEY (idMecanico),
    CONSTRAINT fk_mecanico_equipe
        FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Ordem de Servico (OS)
-- ============================================================
CREATE TABLE OrdemServico (
    idOS            INT          NOT NULL AUTO_INCREMENT,
    numero          VARCHAR(20)  NOT NULL UNIQUE,
    dataEmissao     DATE         NOT NULL,
    dataConclusao   DATE,
    status          ENUM('Aguardando Autorização','Autorizada','Em Execução','Concluída','Cancelada')
                                 NOT NULL DEFAULT 'Aguardando Autorização',
    valorTotal      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    observacao      TEXT,
    idVeiculo       INT          NOT NULL,
    idEquipe        INT          NOT NULL,
    PRIMARY KEY (idOS),
    CONSTRAINT fk_os_veiculo
        FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_os_equipe
        FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Autorizacao (cliente autoriza a OS)
-- ============================================================
CREATE TABLE Autorizacao (
    idAutorizacao   INT          NOT NULL AUTO_INCREMENT,
    idOS            INT          NOT NULL,
    idCliente       INT          NOT NULL,
    dataAutorizacao DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    autorizado      TINYINT(1)   NOT NULL DEFAULT 0,
    PRIMARY KEY (idAutorizacao),
    CONSTRAINT fk_auth_os
        FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_auth_cliente
        FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Tabela de Referencia de Mao de Obra
-- ============================================================
CREATE TABLE TabelaMaoDeObra (
    idMaoDeObra     INT          NOT NULL AUTO_INCREMENT,
    descricao       VARCHAR(150) NOT NULL,
    valorReferencia DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idMaoDeObra)
);

-- ============================================================
-- TABELA: Servico (serviços disponíveis)
-- ============================================================
CREATE TABLE Servico (
    idServico       INT          NOT NULL AUTO_INCREMENT,
    descricao       VARCHAR(150) NOT NULL,
    idMaoDeObra     INT          NOT NULL,
    PRIMARY KEY (idServico),
    CONSTRAINT fk_servico_mdo
        FOREIGN KEY (idMaoDeObra) REFERENCES TabelaMaoDeObra(idMaoDeObra)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: OS_Servico  (serviços vinculados a uma OS)
-- ============================================================
CREATE TABLE OS_Servico (
    idOS            INT          NOT NULL,
    idServico       INT          NOT NULL,
    quantidade      INT          NOT NULL DEFAULT 1,
    valorUnitario   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOS, idServico),
    CONSTRAINT fk_osserv_os
        FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_osserv_servico
        FOREIGN KEY (idServico) REFERENCES Servico(idServico)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- TABELA: Peca
-- ============================================================
CREATE TABLE Peca (
    idPeca          INT          NOT NULL AUTO_INCREMENT,
    codigo          VARCHAR(30)  NOT NULL UNIQUE,
    descricao       VARCHAR(150) NOT NULL,
    valorUnitario   DECIMAL(10,2) NOT NULL,
    estoque         INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (idPeca)
);

-- ============================================================
-- TABELA: OS_Peca  (peças utilizadas em uma OS)
-- ============================================================
CREATE TABLE OS_Peca (
    idOS            INT          NOT NULL,
    idPeca          INT          NOT NULL,
    quantidade      INT          NOT NULL DEFAULT 1,
    valorUnitario   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOS, idPeca),
    CONSTRAINT fk_ospeca_os
        FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ospeca_peca
        FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
        ON DELETE RESTRICT ON UPDATE CASCADE
);