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

def discount_x_percent(items, discount_point, x)
  sum = items.inject(0) { |sum, item| sum += item.price }
  sum = sum * (100 - x) / 100 if sum >= discount_point
  sum.round(2)
end

def discount_by_drop_price(items, drop_code, drop_price, min_amount)
  discountable = items.select { |item| item.code == drop_code }.size >= min_amount
  sum = items.inject(0) do |sum, item|
    sum += item.code == (discountable && drop_code) ? drop_price : item.price
  end
  sum.round(2)
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

    # rule1 = LogivanTest::DiscountByAmountSpecificItemRule.new(apply_code: items.first.code, amount_items: 2, discount_price: 8.50)
    rule2 = LogivanTest::DiscountByTotalPriceRule.new(discount_point: 60, percent_discount: 10)
    promotion_rules = [rule2]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    items.each do |item|
      checkout.scan item
    end
    price_without_discount = items.inject(0) { |sum, item| sum += item.price }
    expect(checkout.total).to be <= price_without_discount
    expect(checkout.total).to be > 60
    expect(checkout.total).to equal(discount_x_percent(items, 60, 10))
  end

  it 'checkout with discount 10 percent 1 item' do
    discount_point = 60.0
    item_price = 50.0
    promotion_rules = [LogivanTest::DiscountByTotalPriceRule.new(discount_point: discount_point, percent_discount: 10)]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    item = create_item; item.price = item_price
    checkout.scan item
    # cannot apply discount
    expect(checkout.total).to equal(item_price)
    checkout.clear_items
    item_price = 60.0
    item.price = item_price
    checkout.scan item

    expect(checkout.total).to equal(item_price * 0.9)
  end

  it 'checkout with discount 10 percent for 100 items' do
    item_price = 60.0
    discount_point = 60.0
    promotion_rules = [LogivanTest::DiscountByTotalPriceRule.new(discount_point: discount_point, percent_discount: 10)]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    100.times do
      item = create_item
      item.price = item_price
      checkout.scan item
    end
    expect(checkout.total).to equal(discount_x_percent(checkout.items, discount_point, 10))
    expect(checkout.total).to equal(item_price * 0.9 * 100)
  end

  it 'checkout with discount 30 percent for 100 items' do
    discount_point = 60.0
    item_price = 60.0
    promotion_rules = [LogivanTest::DiscountByTotalPriceRule.new(discount_point: discount_point, percent_discount: 30)]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    100.times do
      item = create_item
      item.price = item_price
      checkout.scan item
    end
    expect(checkout.total).to equal(discount_x_percent(checkout.items, discount_point, 30))
    expect(checkout.total).to equal(item_price * 0.7 * 100)
  end

  it 'checkout with discount by drop price' do
    item_price = 50.0
    discount_price = 40.0
    item = create_item; item.price = item_price
    promotion_rules = [
      LogivanTest::DiscountByAmountSpecificItemRule.new(
        apply_code: item.code, amount_items: 1, discount_price: discount_price
      )
    ]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    checkout.scan item
    expect(checkout.total).to equal(discount_price)

    item2 = create_item; item2.price = item_price; item2.code = item.code
    checkout.scan item
    expect(checkout.total).to equal(discount_price * 2)
  end

  it 'checkout with discount by drop price with 100 items' do
    discount_price = 40.0
    item_price = 50.0
    apply_code = '001'
    promotion_rules = [
      LogivanTest::DiscountByAmountSpecificItemRule.new(
        apply_code: apply_code, amount_items: 1, discount_price: discount_price
      )
    ]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    100.times do
      item = create_item
      item.code = apply_code
      item.price = item_price
      checkout.scan item
    end
    expect(checkout.total).to equal(discount_price * 100)
  end

  it 'should error when discount price bigger than normal price' do
    discount_price = 60.0
    item_price = 50.0
    apply_code = '001'
    promotion_rules = [
      LogivanTest::DiscountByAmountSpecificItemRule.new(
        apply_code: apply_code, amount_items: 1, discount_price: discount_price
      )
    ]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    item = create_item
    item.code = apply_code
    item.price = item_price
    checkout.scan item
    expect { checkout.total }.to raise_error('Error: The price of discount have to smaller than common price')
  end
end
