module FactoryHelpers
  def create(model_name, attributes = {})
    case model_name
    when :investment_category
      slug = attributes[:slug] || "#{attributes[:name] || 'stocks'}-#{SecureRandom.hex(4)}".parameterize
      InvestmentCategory.create!({
        name: 'Stocks',
        slug: slug
      }.merge(attributes))
    when :investment_type
      InvestmentType.create!({
        name: 'Default Investment',
        base_price: 100.0,
        investment_category: attributes[:investment_category] || create(:investment_category)
      }.merge(attributes))
    when :simulation
      Simulation.create!({
        initial_capital: 10000.0,
        current_capital: 10000.0,
        months_elapsed: 0,
        investment_type: attributes[:investment_type] || create(:investment_type)
      }.merge(attributes))
    else
      raise "Unknown factory: #{model_name}"
    end
  end
end

RSpec.configure do |config|
  config.include FactoryHelpers
end
