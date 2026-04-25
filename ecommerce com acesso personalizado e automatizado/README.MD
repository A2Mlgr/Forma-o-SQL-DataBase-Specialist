E-Commerce & Management — Projeto de Banco de Dados
Este repositório contém o projeto lógico avançado de um sistema de E-Commerce e um módulo de Gestão Organizacional, desenvolvido em MySQL e gerenciado via DBeaver. O projeto integra modelagem relacional, automação via triggers e controle de acesso via views e permissões.

Funcionalidades Principais
Modelo E-Commerce: Suporte a Clientes PF/PJ (herança), múltiplos pagamentos, controle de estoque e logística com rastreio detalhado.

Gestão de Acessos (Views): Camadas de abstração para relatórios de RH e produtividade de projetos.

Automação (Triggers): Auditoria automática de contas excluídas e validação de integridade de preços.

Segurança: Políticas de privilégios para perfis de Gerente e Funcionário.

Estrutura do Banco de Dados
Modelo Lógico (E-Commerce)
O sistema utiliza o padrão Table Per Type (TPT) para gerir a especialização de contas:

Conta: Entidade base com email e tipo (PF/PJ).

ClientePF / ClientePJ: Extensões da conta com atributos específicos (CPF/CNPJ).

Pedido & Pagamento: Relação N:M permitindo que um pedido seja pago com múltiplas formas (Cartão + PIX, etc.).

Camada de Inteligência (Views)
Foram implementadas visões para simplificar a análise de dados:

vw_func_dept_local: Quantitativo de colaboradores por região.

vw_depto_gerentes: Mapeamento direto de lideranças.

vw_projetos_mais_alocados: Ranking de projetos por volume de pessoal.

vw_empregados_dependentes_gerentes: Visão consolidada de benefícios e cargos.

Gatilhos e Integridade
Para garantir a consistência dos dados, o sistema conta com:

Log de Exclusão (BEFORE DELETE): Antes de remover uma conta, os dados básicos são movidos para Log_Contas_Excluidas, garantindo rastro de auditoria.

Validação de Preços (BEFORE UPDATE): Impede que produtos sejam registrados com valores negativos ou zerados na tabela Produto.

Como Executar no DBeaver
Conexão: Configure sua conexão MySQL local ou remota no DBeaver.

Execução do Script:

Abra o arquivo .sql.

Utilize o atalho Alt + X para executar o script completo (incluindo os blocos de DELIMITER dos triggers).

Atualização:

Clique com o botão direito no seu Schema e selecione Refresh (F5) para visualizar as novas Views e Triggers no navegador lateral.

Diagrama ER:

Clique duas vezes no Schema -> Aba ER Diagram.

Ative o filtro Show Views para visualizar a relação entre as tabelas e as camadas de visualização.

 Consultas Analíticas (Exemplos)
O script inclui 15 queries complexas, cobrindo:

Ticket médio por cliente.

Margem bruta de produtos por fornecedor.

Histórico de rastreio em tempo real.

Receita total por categoria de produto.