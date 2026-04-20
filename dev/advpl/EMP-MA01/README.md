Teste Técnico ADVPL / TL++ - Carlos Batista
Repositório destinado à apresentação dos desafios técnicos. Os fontes foram desenvolvidos focando em performance, boas práticas de codificação e aderência aos padrões atuais da TOTVS.

->Tecnologias e Padrões Utilizados
Linguagem: ADVPL / TL++
Banco de Dados: PostgreSQL (Consultas via Embedded SQL / BeginSQL)
Integração: REST API (TLPP) com manipulação de JSON
Performance: Uso de MSExecAuto para processamento em lote e queries otimizadas.

->Desafios Desenvolvidos
1. Importador de Clientes (CSV)
Arquivo: /src/update/importaCSV.tlpp
Descrição: Rotina para importação massiva de dados na base de dados SA1 utilizando MSExecAuto.
Destaques: * Seleção de arquivo via interface padrão.
Tratamento de erros e logs de processamento.

2. API CRUD Clientes (REST)
Arquivo: /src/api/crudClientes.tlpp
Descrição: Webservice para integração de dados da tabela SA1.
Implementação dos métodos GET, POST, PUT e DELETE.
Validação de status codes (200, 201, 400, 404, 500).

3. Relatório de Clientes (TXT/CSV)
Arquivo: /src/report/relatorioClientesCSV.tlpp
Descrição: Exportador de dados para formato texto com diretório escolhido pelo usuário.
Uso da classe FWFileWriter ideal para grandes volumes.

4. Relatório em TReport (Clientes com Vendas)
Arquivo: /src/report/treportClientes.prw
Descrição: Relatório utilizando a engine TReport.
Lógica de Negócio: Filtra apenas clientes ativos com movimentação real de vendas (Join SA1 x SC5 x SC6).
Cálculo dinâmico do valor total vendido por cliente.

5. Função de Busca de Produtos (Query Dinâmica)
Arquivo: /src/utils/getProdutos.prw
Descrição: Função getProdutos() com filtros condicionais e procuraProdutos() com sql dinâmica.
Observações: Usado o campo B1_PRV1 para validação de preço. Criação de uma GUI para entrada de dados e saída.
Saída detalhada no console do AppServer.

📁 Organização do Repositório
Plaintext
├── src/
│   ├── api/             # Fontes da API REST
│   ├── reports/         # Relatórios TXT e TReport
│   ├── updates/         # Importador e ExecAuto
│   └── utils/           # Função de busca de produtos e utilitários
├── data/
│   └── carga_clientes.csv # Arquivo de exemplo utilizado nos testes
|   └── json.txt # Lista com os Json's utilizados no Postman para construção e validação da API
|
└── README.md