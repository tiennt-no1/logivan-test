# frozen_string_literal: true

require 'rspec'
require 'yaml'
require 'pry'
require_relative '../lib/checkout.rb'
require_relative '../lib/rule.rb'
require_relative '../lib/rules/discount_by_amount_specific_item_rule.rb'
require_relative '../lib/rules/discount_by_total_price_rule.rb'
require_relative '../lib/item.rb'
require_relative './spec_helper.rb'

def discount_10_percent(items, discount_point)
  sum = items.inject(0){|sum, item| sum += item.price}
  sum = sum*90/100 if sum >= discount_point
  sum
end

RSpec.describe LogivanTest::Checkout do
  it 'invalid init checkout' do
    expect { LogivanTest::Checkout.new }.to raise_error(ArgumentError)
    expect { LogivanTest::Checkout.new([]) }.to raise_error('Error: rules cannot empty!')
    expect { LogivanTest::Checkout.new([1, 2, 3]) }.to raise_error('Error: invalid input promotion rule!')
  end

  it 'invalid input scan item' do
    rule1 = LogivanTest::Rule.new
    rule2 = LogivanTest::Rule.new
    checkout = LogivanTest::Checkout.new([rule1, rule2])
    expect { checkout.scan }.to raise_error(ArgumentError)
    expect { checkout.scan(1) }.to raise_error('Error: cannot scan invalid item!')
    expect { checkout.scan({}) }.to raise_error('Error: cannot scan invalid item!')
  end

  it 'test checkout 10 percent ' do
    # load items from fixture
    fixture = YAML.load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'fixture.yml'))
    items_data = fixture['items']
    items = items_data.map { |d| LogivanTest::Item.new(d) }
    items.each do |item|
      expect(item.valid?).to be true
    end

    # items list
    # <LogivanTest::Item:0x0000555c83593168 @code=1, @name="Lavender heart", @price=9.25>,
    # <LogivanTest::Item:0x0000555c83593078 @code=2, @name="Personalised cufflinks", @price=45.0>,
    # <LogivanTest::Item:0x0000555c83592f88 @code=3, @name="kids T-shirt", @price=19.95>

    # rule1 = LogivanTest::DiscountByAmountSpecificItemRule.new(code_apply: items.first.code, amount_items: 2, discount_price: 8.50)
    rule2 = LogivanTest::DiscountByTotalPriceRule.new(discount_point: 60, percent_discount: 10)
    promotion_rules = [ rule2]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    items.each do |item|
      checkout.scan item
    end
    price_without_discount = items.inject(0){ |sum, item| sum += item.price}
    expect(checkout.total).to be <= (price_without_discount)
    expect(checkout.total).to be > (60)
    expect(checkout.total).to equal(discount_10_percent(items, 60))
  end
end
