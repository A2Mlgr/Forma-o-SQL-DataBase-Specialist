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

-- ============================================================
-- PROJETO LÓGICO - SISTEMA DE OFICINA MECÂNICA
-- Compatível com MariaDB no DBeaver
-- INSTRUÇÃO: Execute o CREATE DATABASE abaixo, depois
-- selecione o banco "oficina_mecanica" no painel esquerdo
-- do DBeaver antes de executar o restante do script.
-- ============================================================

CREATE DATABASE IF NOT EXISTS oficina_mecanica;

-- ============================================================
-- SCHEMA — DDL
-- ============================================================

CREATE TABLE Cliente (
    idCliente   INT          NOT NULL AUTO_INCREMENT,
    nome        VARCHAR(100) NOT NULL,
    cpf_cnpj    VARCHAR(18)  NOT NULL UNIQUE,
    telefone    VARCHAR(20),
    email       VARCHAR(100),
    endereco    VARCHAR(255),
    tipo        ENUM('PF','PJ') NOT NULL DEFAULT 'PF',
    PRIMARY KEY (idCliente)
);

CREATE TABLE Veiculo (
    idVeiculo   INT         NOT NULL AUTO_INCREMENT,
    placa       VARCHAR(10) NOT NULL UNIQUE,
    marca       VARCHAR(50) NOT NULL,
    modelo      VARCHAR(50) NOT NULL,
    ano         YEAR        NOT NULL,
    cor         VARCHAR(30),
    idCliente   INT         NOT NULL,
    PRIMARY KEY (idVeiculo),
    CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Equipe (
    idEquipe INT         NOT NULL AUTO_INCREMENT,
    nome     VARCHAR(80) NOT NULL,
    PRIMARY KEY (idEquipe)
);

CREATE TABLE Mecanico (
    idMecanico    INT          NOT NULL AUTO_INCREMENT,
    codigo        VARCHAR(20)  NOT NULL UNIQUE,
    nome          VARCHAR(100) NOT NULL,
    endereco      VARCHAR(255),
    especialidade VARCHAR(80)  NOT NULL,
    idEquipe      INT,
    PRIMARY KEY (idMecanico),
    CONSTRAINT fk_mecanico_equipe
        FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE TabelaMaoDeObra (
    idMaoDeObra     INT           NOT NULL AUTO_INCREMENT,
    descricao       VARCHAR(150)  NOT NULL,
    valorReferencia DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idMaoDeObra)
);

CREATE TABLE Servico (
    idServico   INT          NOT NULL AUTO_INCREMENT,
    descricao   VARCHAR(150) NOT NULL,
    idMaoDeObra INT          NOT NULL,
    PRIMARY KEY (idServico),
    CONSTRAINT fk_servico_mdo
        FOREIGN KEY (idMaoDeObra) REFERENCES TabelaMaoDeObra(idMaoDeObra)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Peca (
    idPeca        INT           NOT NULL AUTO_INCREMENT,
    codigo        VARCHAR(30)   NOT NULL UNIQUE,
    descricao     VARCHAR(150)  NOT NULL,
    valorUnitario DECIMAL(10,2) NOT NULL,
    estoque       INT           NOT NULL DEFAULT 0,
    PRIMARY KEY (idPeca)
);

CREATE TABLE OrdemServico (
    idOS          INT           NOT NULL AUTO_INCREMENT,
    numero        VARCHAR(20)   NOT NULL UNIQUE,
    dataEmissao   DATE          NOT NULL,
    dataConclusao DATE,
    status        ENUM('Aguardando Autorizacao','Autorizada','Em Execucao','Concluida','Cancelada')
                                NOT NULL DEFAULT 'Aguardando Autorizacao',
    valorTotal    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    observacao    TEXT,
    idVeiculo     INT           NOT NULL,
    idEquipe      INT           NOT NULL,
    PRIMARY KEY (idOS),
    CONSTRAINT fk_os_veiculo
        FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_os_equipe
        FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Autorizacao (
    idAutorizacao   INT        NOT NULL AUTO_INCREMENT,
    idOS            INT        NOT NULL,
    idCliente       INT        NOT NULL,
    dataAutorizacao DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    autorizado      TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (idAutorizacao),
    CONSTRAINT fk_auth_os
        FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_auth_cliente
        FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE OS_Servico (
    idOS          INT           NOT NULL,
    idServico     INT           NOT NULL,
    quantidade    INT           NOT NULL DEFAULT 1,
    valorUnitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOS, idServico),
    CONSTRAINT fk_osserv_os
        FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_osserv_servico
        FOREIGN KEY (idServico) REFERENCES Servico(idServico)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE OS_Peca (
    idOS          INT           NOT NULL,
    idPeca        INT           NOT NULL,
    quantidade    INT           NOT NULL DEFAULT 1,
    valorUnitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOS, idPeca),
    CONSTRAINT fk_ospeca_os
        FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ospeca_peca
        FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- DADOS DE TESTE — DML
-- ============================================================

INSERT INTO Cliente (nome, cpf_cnpj, telefone, email, endereco, tipo) VALUES
('Carlos Mendes',          '11122233344',    '11999991111', 'carlos@email.com',  'Rua A, 100, Sao Paulo, SP',      'PF'),
('Ana Paula Souza',        '55566677788',    '21988882222', 'ana@email.com',     'Av. B, 200, Rio de Janeiro, RJ', 'PF'),
('Transportes Silva LTDA', '12345678000190', '11333333333', 'silva@transp.com',  'Rod. C, 500, Campinas, SP',      'PJ'),
('Joao Lima',              '99900011122',    '31977773333', 'joao@email.com',    'Rua D, 50, BH, MG',              'PF'),
('Logistica Norte LTDA',   '98765432000155', '92955554444', 'norte@log.com',     'Av. E, 900, Manaus, AM',         'PJ'),
('Maria Fernanda Costa',   '33344455566',    '85966665555', 'maria@email.com',   'Rua F, 80, Fortaleza, CE',       'PF');

INSERT INTO Veiculo (placa, marca, modelo, ano, cor, idCliente) VALUES
('ABC1D23', 'Toyota',     'Corolla',  2020, 'Prata',   1),
('XYZ2E34', 'Honda',      'Civic',    2019, 'Preto',   2),
('QWE3F45', 'Ford',       'Ranger',   2021, 'Branco',  3),
('RTY4G56', 'Volkswagen', 'Gol',      2018, 'Azul',    4),
('UIO5H67', 'Mercedes',   'Sprinter', 2022, 'Branco',  5),
('PAS6J78', 'Chevrolet',  'Onix',     2023, 'Vermelho',6),
('LKJ7K89', 'Ford',       'Fiesta',   2017, 'Cinza',   1),
('MNB8L90', 'Toyota',     'Hilux',    2021, 'Preto',   3);

INSERT INTO Equipe (nome) VALUES
('Equipe Alpha'),
('Equipe Beta'),
('Equipe Gamma');

INSERT INTO Mecanico (codigo, nome, endereco, especialidade, idEquipe) VALUES
('MEC001', 'Roberto Alves',  'Rua 1, 10, SP', 'Motor',           1),
('MEC002', 'Fernanda Lima',  'Rua 2, 20, SP', 'Eletrica',        1),
('MEC003', 'Paulo Henrique', 'Rua 3, 30, SP', 'Suspensao',       2),
('MEC004', 'Juliana Matos',  'Rua 4, 40, RJ', 'Funilaria',       2),
('MEC005', 'Ricardo Gomes',  'Rua 5, 50, MG', 'Motor',           3),
('MEC006', 'Patricia Nunes', 'Rua 6, 60, MG', 'Transmissao',     3),
('MEC007', 'Diego Souza',    'Rua 7, 70, SP', 'Eletrica',        1),
('MEC008', 'Camila Rocha',   'Rua 8, 80, SP', 'Ar-Condicionado', 2);

INSERT INTO TabelaMaoDeObra (descricao, valorReferencia) VALUES
('Troca de oleo e filtro',           80.00),
('Revisao de freios',               150.00),
('Alinhamento e balanceamento',     120.00),
('Troca de correia dentada',        350.00),
('Diagnostico eletronico',           90.00),
('Revisao do ar-condicionado',      200.00),
('Troca de embreagem',              500.00),
('Funilaria e pintura por painel',  400.00);

INSERT INTO Servico (descricao, idMaoDeObra) VALUES
('Troca de oleo 5W30 + filtro',          1),
('Revisao completa de freios dianteiros', 2),
('Alinhamento 3D + balanceamento',        3),
('Troca de correia dentada + tensor',     4),
('Diagnostico de falha no motor',         5),
('Recarga e limpeza do ar-condicionado',  6),
('Troca de embreagem completa',           7),
('Reparos de funilaria lateral',          8);

INSERT INTO Peca (codigo, descricao, valorUnitario, estoque) VALUES
('OL001', 'Oleo Motor 5W30 1L',          25.00, 100),
('FL001', 'Filtro de Oleo',              35.00,  80),
('FR001', 'Pastilha de Freio Dianteira', 90.00,  60),
('FR002', 'Disco de Freio Dianteiro',   180.00,  40),
('CD001', 'Correia Dentada',            220.00,  30),
('CD002', 'Tensor da Correia',          130.00,  25),
('AC001', 'Gas Refrigerante R134a',      80.00,  50),
('EM001', 'Kit Embreagem Completo',     450.00,  20),
('FL002', 'Filtro de Ar',               45.00,  70),
('SP001', 'Vela de Ignicao jogo 4',    120.00,  55);

INSERT INTO OrdemServico (numero, dataEmissao, dataConclusao, status, valorTotal, observacao, idVeiculo, idEquipe) VALUES
('OS-2024-001', '2024-01-15', '2024-01-16', 'Concluida',             285.00, 'Revisao periodica',           1, 1),
('OS-2024-002', '2024-01-20', '2024-01-22', 'Concluida',             620.00, 'Freios com ruido',            2, 2),
('OS-2024-003', '2024-02-05', '2024-02-07', 'Concluida',             820.00, 'Troca preventiva da correia', 3, 1),
('OS-2024-004', '2024-02-10', NULL,          'Em Execucao',            90.00, 'Luz de falha acesa',          4, 3),
('OS-2024-005', '2024-02-18', '2024-02-20', 'Concluida',            1150.00, 'Embreagem patinando',         5, 2),
('OS-2024-006', '2024-03-01', '2024-03-01', 'Concluida',             200.00, 'Revisao de AC',               6, 3),
('OS-2024-007', '2024-03-10', NULL,          'Aguardando Autorizacao',  0.00, 'Funilaria lateral',           7, 2),
('OS-2024-008', '2024-03-15', '2024-03-17', 'Concluida',             470.00, 'Revisao 30.000km',            8, 1),
('OS-2024-009', '2024-04-02', NULL,          'Autorizada',            350.00, 'Correia dentada preventiva',  1, 3),
('OS-2024-010', '2024-04-10', NULL,          'Cancelada',               0.00, 'Cliente cancelou',            2, 1);

INSERT INTO Autorizacao (idOS, idCliente, dataAutorizacao, autorizado) VALUES
(1,  1, '2024-01-15 09:00:00', 1),
(2,  2, '2024-01-20 10:30:00', 1),
(3,  3, '2024-02-05 08:00:00', 1),
(4,  4, '2024-02-10 11:00:00', 1),
(5,  5, '2024-02-18 14:00:00', 1),
(6,  6, '2024-03-01 09:30:00', 1),
(7,  1, '2024-03-10 15:00:00', 0),
(8,  3, '2024-03-15 08:00:00', 1),
(9,  1, '2024-04-02 10:00:00', 1),
(10, 2, '2024-04-10 09:00:00', 0);

INSERT INTO OS_Servico (idOS, idServico, quantidade, valorUnitario) VALUES
(1, 1, 1,  80.00),
(1, 3, 1, 120.00),
(2, 2, 1, 150.00),
(3, 4, 1, 350.00),
(4, 5, 1,  90.00),
(5, 7, 1, 500.00),
(6, 6, 1, 200.00),
(8, 1, 1,  80.00),
(8, 3, 1, 120.00),
(9, 4, 1, 350.00);

INSERT INTO OS_Peca (idOS, idPeca, quantidade, valorUnitario) VALUES
(1,  1, 4,  25.00),
(1,  2, 1,  35.00),
(2,  3, 1,  90.00),
(2,  4, 1, 180.00),
(3,  5, 1, 220.00),
(3,  6, 1, 130.00),
(5,  8, 1, 450.00),
(5,  7, 1,  80.00),
(6,  7, 1,  80.00),
(8,  1, 4,  25.00),
(8,  2, 1,  35.00),
(8,  9, 1,  45.00),
(8, 10, 1, 120.00),
(9,  5, 1, 220.00),
(9,  6, 1, 130.00);

-- ============================================================
-- QUERIES
-- ============================================================

-- Q1: Mecânicos e especialidades por equipe
SELECT m.codigo, m.nome, m.especialidade, e.nome AS equipe
FROM Mecanico m
LEFT JOIN Equipe e ON m.idEquipe = e.idEquipe
ORDER BY e.nome, m.nome;

-- Q2: OS concluídas
SELECT os.numero, os.dataEmissao, os.dataConclusao, os.valorTotal, v.placa, v.modelo
FROM OrdemServico os
INNER JOIN Veiculo v ON os.idVeiculo = v.idVeiculo
WHERE os.status = 'Concluida'
ORDER BY os.dataConclusao DESC;

-- Q3: Prazo de execução em dias (atributo derivado)
SELECT
    os.numero,
    os.status,
    os.dataEmissao,
    os.dataConclusao,
    DATEDIFF(os.dataConclusao, os.dataEmissao) AS diasExecucao,
    os.valorTotal,
    ROUND(os.valorTotal / NULLIF(DATEDIFF(os.dataConclusao, os.dataEmissao), 0), 2) AS valorPorDia
FROM OrdemServico os
WHERE os.dataConclusao IS NOT NULL
ORDER BY diasExecucao DESC;

-- Q4: Total de OS e valor gasto por cliente
SELECT
    c.idCliente,
    c.nome AS cliente,
    c.tipo,
    COUNT(os.idOS)             AS totalOS,
    SUM(os.valorTotal)         AS totalGasto,
    ROUND(AVG(os.valorTotal), 2) AS ticketMedio
FROM Cliente c
LEFT JOIN Veiculo v       ON c.idCliente  = v.idCliente
LEFT JOIN OrdemServico os ON v.idVeiculo  = os.idVeiculo
GROUP BY c.idCliente, c.nome, c.tipo
ORDER BY totalGasto DESC;

-- Q5: Equipes com faturamento > R$500 em OS concluídas (HAVING)
SELECT
    eq.nome                      AS equipe,
    COUNT(os.idOS)               AS totalOS,
    SUM(os.valorTotal)           AS faturamentoTotal,
    ROUND(AVG(os.valorTotal), 2) AS mediaPorOS
FROM Equipe eq
INNER JOIN OrdemServico os ON eq.idEquipe = os.idEquipe
WHERE os.status = 'Concluida'
GROUP BY eq.nome
HAVING SUM(os.valorTotal) > 500
ORDER BY faturamentoTotal DESC;

-- Q6: Detalhamento completo da OS-2024-008 (serviços + peças)
SELECT os.numero, 'Servico' AS tipo, s.descricao AS item,
       oss.quantidade, oss.valorUnitario,
       (oss.quantidade * oss.valorUnitario) AS subtotal
FROM OrdemServico os
INNER JOIN OS_Servico oss ON os.idOS      = oss.idOS
INNER JOIN Servico s      ON oss.idServico = s.idServico
WHERE os.numero = 'OS-2024-008'
UNION ALL
SELECT os.numero, 'Peca' AS tipo, p.descricao AS item,
       osp.quantidade, osp.valorUnitario,
       (osp.quantidade * osp.valorUnitario) AS subtotal
FROM OrdemServico os
INNER JOIN OS_Peca osp ON os.idOS   = osp.idOS
INNER JOIN Peca p      ON osp.idPeca = p.idPeca
WHERE os.numero = 'OS-2024-008'
ORDER BY tipo, item;

-- Q7: Custo mão de obra vs peças por OS (atributo derivado)
SELECT
    os.numero,
    os.status,
    COALESCE(srv.totalServicos, 0) AS custoServicos,
    COALESCE(pcs.totalPecas, 0)    AS custoPecas,
    COALESCE(srv.totalServicos, 0) + COALESCE(pcs.totalPecas, 0) AS custoCalculado,
    os.valorTotal AS valorRegistrado,
    ROUND(
        COALESCE(srv.totalServicos, 0) /
        NULLIF(COALESCE(srv.totalServicos,0) + COALESCE(pcs.totalPecas,0), 0) * 100
    , 2) AS percMaoDeObra
FROM OrdemServico os
LEFT JOIN (SELECT idOS, SUM(quantidade * valorUnitario) AS totalServicos FROM OS_Servico GROUP BY idOS) srv ON os.idOS = srv.idOS
LEFT JOIN (SELECT idOS, SUM(quantidade * valorUnitario) AS totalPecas    FROM OS_Peca    GROUP BY idOS) pcs ON os.idOS = pcs.idOS
ORDER BY os.numero;

-- Q8: Veículos de clientes PJ com OS em aberto
SELECT
    c.nome AS empresa, v.placa, v.marca, v.modelo,
    os.numero, os.status, os.dataEmissao, eq.nome AS equipe
FROM Cliente c
INNER JOIN Veiculo v       ON c.idCliente = v.idCliente
INNER JOIN OrdemServico os ON v.idVeiculo  = os.idVeiculo
INNER JOIN Equipe eq       ON os.idEquipe  = eq.idEquipe
WHERE c.tipo = 'PJ'
  AND os.status NOT IN ('Concluida', 'Cancelada')
ORDER BY c.nome, os.dataEmissao;

-- Q9: Peças mais utilizadas com alerta de estoque (CASE WHEN)
SELECT
    p.codigo,
    p.descricao AS peca,
    SUM(osp.quantidade) AS totalUsado,
    SUM(osp.quantidade * osp.valorUnitario) AS receitaGerada,
    p.estoque AS estoqueAtual,
    CASE
        WHEN p.estoque < 10 THEN 'CRITICO'
        WHEN p.estoque < 30 THEN 'BAIXO'
        ELSE 'OK'
    END AS alertaEstoque
FROM Peca p
LEFT JOIN OS_Peca osp ON p.idPeca = osp.idPeca
GROUP BY p.idPeca, p.codigo, p.descricao, p.estoque
ORDER BY totalUsado DESC;

-- Q10: Mecânicos por equipe e OS atendidas
SELECT
    eq.nome AS equipe,
    COUNT(DISTINCT m.idMecanico) AS qtdMecanicos,
    COUNT(DISTINCT os.idOS)      AS totalOS,
    SUM(os.valorTotal)           AS faturamento,
    GROUP_CONCAT(DISTINCT m.especialidade ORDER BY m.especialidade SEPARATOR ', ') AS especialidades
FROM Equipe eq
LEFT JOIN Mecanico m      ON eq.idEquipe = m.idEquipe
LEFT JOIN OrdemServico os ON eq.idEquipe = os.idEquipe
GROUP BY eq.idEquipe, eq.nome
ORDER BY faturamento DESC;

-- Q11: Clientes com mais de 1 veículo (HAVING)
SELECT
    c.idCliente, c.nome, c.tipo,
    COUNT(v.idVeiculo) AS totalVeiculos,
    GROUP_CONCAT(v.placa ORDER BY v.placa SEPARATOR ', ') AS placas
FROM Cliente c
INNER JOIN Veiculo v ON c.idCliente = v.idCliente
GROUP BY c.idCliente, c.nome, c.tipo
HAVING COUNT(v.idVeiculo) > 1
ORDER BY totalVeiculos DESC;

-- Q12: Serviços mais executados e rentáveis
SELECT
    s.descricao AS servico,
    mdo.valorReferencia AS valorTabela,
    COUNT(oss.idOS) AS vezesExecutado,
    SUM(oss.quantidade * oss.valorUnitario) AS receitaTotal,
    ROUND(AVG(oss.valorUnitario), 2) AS precoMedioCobrado,
    ROUND(AVG(oss.valorUnitario) - mdo.valorReferencia, 2) AS desvioTabela
FROM Servico s
INNER JOIN TabelaMaoDeObra mdo ON s.idMaoDeObra = mdo.idMaoDeObra
LEFT JOIN OS_Servico oss       ON s.idServico   = oss.idServico
GROUP BY s.idServico, s.descricao, mdo.valorReferencia
ORDER BY receitaTotal DESC;

-- Q13: Histórico completo do veículo ABC1D23
SELECT
    v.placa, v.marca, v.modelo, v.ano,
    c.nome AS proprietario,
    os.numero, os.dataEmissao, os.dataConclusao,
    os.status, os.valorTotal, eq.nome AS equipe, os.observacao
FROM Veiculo v
INNER JOIN Cliente c       ON v.idCliente  = c.idCliente
INNER JOIN OrdemServico os ON v.idVeiculo  = os.idVeiculo
INNER JOIN Equipe eq       ON os.idEquipe  = eq.idEquipe
WHERE v.placa = 'ABC1D23'
ORDER BY os.dataEmissao;

-- Q14: OS aguardando autorização ou não autorizadas
SELECT
    os.numero, os.dataEmissao, os.status,
    c.nome AS cliente, c.telefone,
    v.placa, v.modelo,
    a.autorizado, a.dataAutorizacao
FROM OrdemServico os
INNER JOIN Veiculo v     ON os.idVeiculo = v.idVeiculo
INNER JOIN Cliente c     ON v.idCliente  = c.idCliente
LEFT JOIN  Autorizacao a ON os.idOS      = a.idOS
WHERE os.status = 'Aguardando Autorizacao' OR a.autorizado = 0
ORDER BY os.dataEmissao;

-- Q15: Faturamento mensal da oficina (HAVING + atributo derivado)
SELECT
    DATE_FORMAT(os.dataEmissao, '%Y-%m')  AS mesAno,
    COUNT(os.idOS)                         AS qtdOS,
    SUM(os.valorTotal)                     AS faturamento,
    ROUND(AVG(os.valorTotal), 2)           AS ticketMedio,
    MAX(os.valorTotal)                     AS maiorOS,
    MIN(CASE WHEN os.valorTotal > 0 THEN os.valorTotal END) AS menorOS
FROM OrdemServico os
WHERE os.status NOT IN ('Cancelada', 'Aguardando Autorizacao')
GROUP BY DATE_FORMAT(os.dataEmissao, '%Y-%m')
HAVING SUM(os.valorTotal) > 0
ORDER BY mesAno;