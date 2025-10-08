# Investment Learner 📈

A Rails application for learning about investments through interactive simulations. Built specifically for Brazilian investors with support for local investment options like Renda Fixa, CDB, Tesouro Direto, and more.

## Features

- **Investment Categories**: Learn about different types of investments (Renda Fixa, Renda Variável, CDB, Ações, ETFs, FIIs, etc.)
- **Interactive Simulations**: Practice buying and selling investments with virtual money
- **Glossary**: Brazilian financial terms explained (IPCA, SELIC, CDI, PUT, CALL, etc.)
- **Real Market Data**: Based on real Brazilian stocks (PETR4, VALE3, ITUB4, etc.)
- **Portfolio Tracking**: See your holdings, profit/loss, and transaction history
- **Time Progression**: Advance time to see how market changes affect your portfolio

## Quick Start

### Prerequisites

- Ruby 3.4.1+
- Docker (for PostgreSQL)
- Bundler

### Bootstrap the Application

Run the bootstrap script to set up everything automatically:

```bash
./bin/bootstrap
```

This will:
- Start PostgreSQL in a Docker container (port 5433)
- Install Ruby gems
- Create and migrate databases
- Load seed data with Brazilian investment options
- Run tests to verify setup

### Start the Application

```bash
bin/dev
```

Visit http://localhost:3000 to start learning!

## Manual Setup

If you prefer to set up manually:

```bash
# Start PostgreSQL
docker compose up -d

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Run tests
bundle exec rspec

# Start server
rails server
```

## Development

### Running Tests

```bash
bundle exec rspec                    # Run all tests
bundle exec rspec spec/models        # Run model tests only
bundle exec rspec spec/controllers   # Run controller tests only
```

### Code Quality Standards

This project follows strict code quality guidelines:
- Maximum 250 lines per file
- Maximum 25 lines per method
- Maximum 1 level of nesting
- TDD approach (Red-Green-Refactor)

### Database

- **Development**: `investment_learner_development`
- **Test**: `investment_learner_test`
- **Host**: localhost:5433
- **User**: yuri
- **Password**: password

## Project Structure

```
app/
├── controllers/          # HTTP request handlers
│   ├── investment_categories_controller.rb
│   ├── glossary_terms_controller.rb
│   ├── simulations_controller.rb
│   └── transactions_controller.rb
├── models/              # Data models
│   ├── investment_category.rb
│   ├── investment_type.rb
│   ├── glossary_term.rb
│   ├── simulation.rb
│   ├── transaction.rb
│   └── portfolio.rb
├── services/            # Business logic
│   └── simulation_engine.rb
└── views/               # HTML templates
    ├── investment_categories/
    ├── glossary_terms/
    └── simulations/

spec/                    # RSpec tests (95 examples, 0 failures)
```

## Available Investment Categories

### Brazilian Options
- **Renda Fixa**: LCI, LCA, Debêntures
- **CDB**: Prefixado, Pós-fixado (CDI), IPCA+
- **Tesouro Direto**: Selic, IPCA+, Prefixado
- **Ações**: PETR4, VALE3, ITUB4, BBDC4, ABEV3, MGLU3, B3SA3
- **FIIs**: HGLG11, MXRF11, XPML11

### International Options
- **ETFs**: BOVA11 (Ibovespa), SMAL11, IVVB11 (S&P 500)
- **Criptomoedas**: Bitcoin, Ethereum, Solana

## Glossary Terms

24 Brazilian financial terms including:
- Market indicators: IPCA, SELIC, CDI, Bovespa, B3
- Investment strategies: PUT, CALL, Short, Long
- Financial metrics: Dividendos, Yield, DY, P/L, ROE
- Key concepts: Liquidez, FGC, Home Broker

## How to Use

1. **Browse Investment Categories**: Start at the home page to explore different investment types
2. **Learn**: Read about what each investment is, how it works, and what affects it
3. **Start a Simulation**: Click "Start Exercise" to practice with virtual money
4. **Trade**: Buy and sell investments at current market prices
5. **Advance Time**: See how your portfolio performs over months
6. **Track Progress**: Monitor your profit/loss and learn from your decisions

## Technology Stack

- **Framework**: Ruby on Rails 8.0.3
- **Database**: PostgreSQL 14
- **Frontend**: Hotwire (Turbo + Stimulus) + Tailwind CSS
- **Testing**: RSpec
- **Containerization**: Docker Compose

## Test Coverage

- 95 test examples
- 0 failures
- Coverage includes:
  - Model validations and business logic
  - Controller actions and responses
  - Simulation engine calculations
  - Portfolio management

## Stopping the Application

```bash
# Stop Rails server
Ctrl + C

# Stop PostgreSQL container
docker compose down
```

## Contributing

This is an educational project for learning about investments and Rails development.

## License

Educational use only.
