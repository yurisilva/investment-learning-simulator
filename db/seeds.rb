# Clear existing data
puts "Clearing existing data..."
InvestmentType.destroy_all
InvestmentCategory.destroy_all
GlossaryTerm.destroy_all

# Investment Categories
puts "Creating investment categories..."

renda_fixa = InvestmentCategory.create!(
  name: "Renda Fixa",
  description: "Investimentos com rentabilidade previsível, geralmente atrelados a índices como CDI ou IPCA. Ideal para quem busca segurança e previsibilidade nos ganhos.",
  how_it_works: "Você empresta dinheiro para instituições (bancos, governo) e recebe juros em troca. A rentabilidade é conhecida no momento da aplicação ou segue índices específicos.",
  affecting_factors: "Taxa SELIC, inflação (IPCA), rating de crédito do emissor, prazo de vencimento, liquidez."
)

renda_variavel = InvestmentCategory.create!(
  name: "Renda Variável",
  description: "Investimentos cujo retorno não pode ser determinado previamente, variando conforme o mercado. Oferece potencial de ganhos maiores com mais riscos.",
  how_it_works: "Compra e venda de ativos negociados na B3 (bolsa brasileira). O lucro vem da valorização do ativo e/ou distribuição de proventos.",
  affecting_factors: "Desempenho da empresa, cenário econômico, taxa de juros, dólar, fluxo de capital estrangeiro, notícias e eventos corporativos."
)

cdb = InvestmentCategory.create!(
  name: "CDB",
  description: "Certificado de Depósito Bancário - título privado emitido por bancos para captar recursos. Protegido pelo FGC até R$ 250 mil.",
  how_it_works: "Ao investir em CDB, você empresta dinheiro ao banco e recebe juros. Pode ser prefixado, pós-fixado (CDI) ou híbrido (IPCA+).",
  affecting_factors: "Solidez do banco emissor, prazo de vencimento, tipo de indexação, taxa SELIC, liquidez oferecida."
)

tesouro = InvestmentCategory.create!(
  name: "Tesouro Direto",
  description: "Títulos públicos emitidos pelo governo federal. Considerado o investimento mais seguro do Brasil.",
  how_it_works: "Você empresta dinheiro ao governo e recebe juros. Existem títulos prefixados, atrelados à SELIC ou ao IPCA.",
  affecting_factors: "Taxa SELIC, expectativas de inflação, classificação de risco do país, demanda por títulos públicos."
)

acoes = InvestmentCategory.create!(
  name: "Ações",
  description: "Frações do capital social de empresas negociadas na B3. Ao comprar uma ação, você se torna sócio da empresa.",
  how_it_works: "Compra e venda através de corretoras na bolsa. Lucros vêm da valorização das ações e pagamento de dividendos.",
  affecting_factors: "Lucro da empresa, governança corporativa, setor econômico, juros, câmbio, expectativas de mercado."
)

etf = InvestmentCategory.create!(
  name: "ETF",
  description: "Exchange Traded Funds - fundos que replicam índices e são negociados como ações na bolsa.",
  how_it_works: "Você compra cotas de um fundo que replica um índice (ex: Ibovespa). Oferece diversificação automática.",
  affecting_factors: "Desempenho do índice replicado, taxa de administração, liquidez do ETF, erro de tracking."
)

fiis = InvestmentCategory.create!(
  name: "Fundos Imobiliários",
  description: "Fundos que investem em imóveis ou títulos do setor imobiliário. Distribuem rendimentos mensais isentos de IR.",
  how_it_works: "Você compra cotas de um fundo que investe em imóveis comerciais, shoppings, galpões. Recebe aluguéis mensalmente.",
  affecting_factors: "Taxa de vacância, valor dos aluguéis, localização dos imóveis, juros, inflação, gestão do fundo."
)

cripto = InvestmentCategory.create!(
  name: "Criptomoedas",
  description: "Moedas digitais descentralizadas baseadas em blockchain. Alta volatilidade e risco.",
  how_it_works: "Compra e venda em exchanges. Valorização puramente especulativa, sem lastro físico ou pagamento de dividendos.",
  affecting_factors: "Adoção tecnológica, regulamentação, sentimento de mercado, notícias, halving (Bitcoin), demanda institucional."
)

# Investment Types
puts "Creating investment types..."

# Renda Fixa
InvestmentType.create!([
  { investment_category: renda_fixa, name: "LCI", base_price: 1000.00 },
  { investment_category: renda_fixa, name: "LCA", base_price: 1000.00 },
  { investment_category: renda_fixa, name: "Debêntures", base_price: 1000.00 }
])

# CDB
InvestmentType.create!([
  { investment_category: cdb, name: "CDB Prefixado", base_price: 1000.00 },
  { investment_category: cdb, name: "CDB Pós-fixado (CDI)", base_price: 1000.00 },
  { investment_category: cdb, name: "CDB IPCA+", base_price: 1000.00 }
])

# Tesouro Direto
InvestmentType.create!([
  { investment_category: tesouro, name: "Tesouro Selic", ticker_symbol: "SELIC", base_price: 100.00 },
  { investment_category: tesouro, name: "Tesouro IPCA+", ticker_symbol: "IPCA+", base_price: 1500.00 },
  { investment_category: tesouro, name: "Tesouro Prefixado", ticker_symbol: "PRE", base_price: 800.00 }
])

# Ações
InvestmentType.create!([
  { investment_category: acoes, name: "Petrobras", ticker_symbol: "PETR4", base_price: 38.50 },
  { investment_category: acoes, name: "Vale", ticker_symbol: "VALE3", base_price: 62.80 },
  { investment_category: acoes, name: "Itaú Unibanco", ticker_symbol: "ITUB4", base_price: 28.90 },
  { investment_category: acoes, name: "Bradesco", ticker_symbol: "BBDC4", base_price: 14.20 },
  { investment_category: acoes, name: "Ambev", ticker_symbol: "ABEV3", base_price: 12.45 },
  { investment_category: acoes, name: "Magazine Luiza", ticker_symbol: "MGLU3", base_price: 8.75 },
  { investment_category: acoes, name: "B3", ticker_symbol: "B3SA3", base_price: 11.50 }
])

# ETFs
InvestmentType.create!([
  { investment_category: etf, name: "BOVA11 (Ibovespa)", ticker_symbol: "BOVA11", base_price: 115.00 },
  { investment_category: etf, name: "SMAL11 (Small Caps)", ticker_symbol: "SMAL11", base_price: 45.00 },
  { investment_category: etf, name: "IVVB11 (S&P 500)", ticker_symbol: "IVVB11", base_price: 280.00 }
])

# FIIs
InvestmentType.create!([
  { investment_category: fiis, name: "HGLG11 (CSHG Logística)", ticker_symbol: "HGLG11", base_price: 145.00 },
  { investment_category: fiis, name: "MXRF11 (Maxi Renda)", ticker_symbol: "MXRF11", base_price: 10.50 },
  { investment_category: fiis, name: "XPML11 (XP Malls)", ticker_symbol: "XPML11", base_price: 95.00 }
])

# Criptomoedas
InvestmentType.create!([
  { investment_category: cripto, name: "Bitcoin", ticker_symbol: "BTC", base_price: 350000.00 },
  { investment_category: cripto, name: "Ethereum", ticker_symbol: "ETH", base_price: 18000.00 },
  { investment_category: cripto, name: "Solana", ticker_symbol: "SOL", base_price: 800.00 }
])

# Glossary Terms
puts "Creating glossary terms..."

GlossaryTerm.create!([
  { term: "IPCA", definition: "Índice de Preços ao Consumidor Amplo - principal indicador de inflação do Brasil, medido pelo IBGE.", related_categories: [ "Renda Fixa", "Tesouro Direto" ] },
  { term: "SELIC", definition: "Sistema Especial de Liquidação e Custódia - taxa básica de juros da economia brasileira, definida pelo COPOM.", related_categories: [ "Renda Fixa", "Tesouro Direto" ] },
  { term: "CDI", definition: "Certificado de Depósito Interbancário - taxa de empréstimos entre bancos, muito próxima à SELIC.", related_categories: [ "Renda Fixa", "CDB" ] },
  {
    term: "PUT",
    definition: "Opção de venda que dá o direito de vender um ativo a um preço predeterminado.",
    related_categories: [ "Renda Variável", "Ações" ]
  },
  {
    term: "CALL",
    definition: "Opção de compra que dá o direito de comprar um ativo a um preço predeterminado.",
    related_categories: [ "Renda Variável", "Ações" ]
  },
  {
    term: "Short",
    definition: "Venda a descoberto - operação especulativa que lucra com a queda do preço de um ativo.",
    related_categories: [ "Renda Variável", "Ações" ]
  },
  {
    term: "Long",
    definition: "Posição comprada - estratégia de comprar e manter ativos esperando valorização.",
    related_categories: [ "Renda Variável", "Ações" ]
  },
  { term: "B3", definition: "Brasil, Bolsa, Balcão - bolsa de valores oficial do Brasil, onde são negociados ações, ETFs e outros ativos.", related_categories: [ "Renda Variável", "Ações", "ETF", "Fundos Imobiliários" ] },
  {
    term: "Dividendos",
    definition: "Parcela do lucro de uma empresa distribuída aos acionistas. Isento de Imposto de Renda para pessoa física.",
    related_categories: [ "Ações" ]
  },
  {
    term: "Yield",
    definition: "Rendimento percentual de um investimento em relação ao seu preço. Em FIIs, representa o retorno mensal.",
    related_categories: [ "Fundos Imobiliários", "Ações" ]
  },
  { term: "Liquidez", definition: "Facilidade de converter um ativo em dinheiro sem perda significativa de valor.", related_categories: [ "Renda Fixa", "Renda Variável" ] },
  { term: "FGC", definition: "Fundo Garantidor de Créditos - protege investimentos em Renda Fixa até R$ 250 mil por CPF e instituição.", related_categories: [ "Renda Fixa", "CDB" ] },
  { term: "Bovespa", definition: "Antiga bolsa de valores de São Paulo, agora parte da B3. Índice Ibovespa representa as principais ações.", related_categories: [ "Ações", "ETF" ] },
  { term: "Home Broker", definition: "Plataforma online para negociar ativos na bolsa de valores através de corretoras.", related_categories: [ "Renda Variável", "Ações" ] },
  { term: "Índice Sharpe", definition: "Métrica que mede o retorno ajustado ao risco de um investimento. Quanto maior, melhor.", related_categories: [ "Renda Variável", "ETF" ] },
  { term: "DY (Dividend Yield)", definition: "Percentual de dividendos pagos em relação ao preço da ação nos últimos 12 meses.", related_categories: [ "Ações" ] },
  { term: "P/L (Preço/Lucro)", definition: "Múltiplo que mostra quantos anos levaria para recuperar o investimento com os lucros atuais da empresa.", related_categories: [ "Ações" ] },
  { term: "P/VP (Preço/Valor Patrimonial)", definition: "Relação entre o preço da ação e o valor patrimonial por ação. Indica se a ação está cara ou barata.", related_categories: [ "Ações" ] },
  { term: "ROE", definition: "Return on Equity - retorno sobre o patrimônio líquido. Mede a eficiência da empresa em gerar lucro.", related_categories: [ "Ações" ] },
  { term: "Volatilidade", definition: "Medida de variação de preço de um ativo. Alta volatilidade indica maior risco e oportunidade.", related_categories: [ "Renda Variável", "Criptomoedas" ] },
  { term: "Spread", definition: "Diferença entre o preço de compra e venda de um ativo. Quanto menor, melhor para o investidor.", related_categories: [ "Renda Variável" ] },
  { term: "Benchmark", definition: "Índice de referência usado para comparar o desempenho de investimentos. Ex: CDI para Renda Fixa.", related_categories: [ "Renda Fixa", "Renda Variável" ] },
  { term: "Taxa de Administração", definition: "Percentual anual cobrado por fundos de investimento para remunerar a gestão.", related_categories: [ "ETF", "Fundos Imobiliários" ] },
  { term: "Aportes", definition: "Aplicações regulares de dinheiro em investimentos para aumentar o patrimônio ao longo do tempo.", related_categories: [ "Renda Fixa", "Renda Variável" ] }
])

puts "Seed data created successfully!"
puts "- #{InvestmentCategory.count} investment categories"
puts "- #{InvestmentType.count} investment types"
puts "- #{GlossaryTerm.count} glossary terms"
