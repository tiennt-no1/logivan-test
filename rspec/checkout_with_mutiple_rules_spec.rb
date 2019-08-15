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
  sum = items.inject(0) { |sum, item| sum += item.price }
  sum = sum * 90 / 100 if sum >= discount_point
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
  let (:discount_price) { 60.0 }
  let (:item_price) { 70.0 }
  let (:discount_point) { 70.0 }
  let (:apply_code) { '001' }
  let (:percent_discount) { 10 }

  def create_sample_item
    item = create_item
    item.code = apply_code
    item.price = item_price
    item
  end

  def create_sample_checkout
    promotion_rules = [
      LogivanTest::DiscountByAmountSpecificItemRule.new(
        apply_code: apply_code, amount_items: 1, discount_price: discount_price
      ),
      LogivanTest::DiscountByTotalPriceRule.new(discount_point: discount_point, percent_discount: percent_discount)
    ]
    checkout = LogivanTest::Checkout.new(promotion_rules)
  end
  

  it 'checkout with 2 promotion rules without priority' do
    checkout = create_sample_checkout
    checkout.scan create_sample_item
    # applied 2 rules based on price_without_discount
    price_without_discount = item_price
    expect_price = discount_price # applied rule 1
    # applied rule 2
    expect_price -= price_without_discount * percent_discount / 100 if price_without_discount >= discount_point
    expect(checkout.total).to equal(expect_price)
  end
  
  it 'should clear item' do
    checkout = create_sample_checkout
    checkout.scan create_sample_item
    checkout.clear_items
    expect(checkout.items.size).to eq(0)
    expect(checkout.total).to eq(0)
  end

  it 'checkout with 2 promotion rules with priority' do
    checkout = create_sample_checkout
    checkout.scan create_sample_item
    # applied 2 rules based on price after apply each rule
    checkout.rules_priority = true
    # applied rule 1
    expect_price = discount_price
    # applied rule 2
    expect_price -= expect_price * percent_discount / 100 if expect_price >= discount_point
    expect(checkout.total).to equal(expect_price)
  end

  it 'checkout with 3 promotion rules with priority, 2 rules discount 10%' do
    discount_point = 1
    promotion_rules = [
      LogivanTest::DiscountByAmountSpecificItemRule.new(
        apply_code: apply_code, amount_items: 1, discount_price: discount_price
      ),
      LogivanTest::DiscountByTotalPriceRule.new(discount_point: discount_point, percent_discount: percent_discount),
      LogivanTest::DiscountByTotalPriceRule.new(discount_point: discount_point, percent_discount: percent_discount)
    ]
    checkout = LogivanTest::Checkout.new(promotion_rules)
    checkout.scan create_sample_item
    # applied 2 rules based on price after apply each rule
    checkout.rules_priority = true
    # apply rule 1
    expect_price = discount_price
    # apply rule 2
    expect_price -= expect_price * percent_discount / 100 if expect_price >= discount_point
    # apply rule 3
    expect_price -= expect_price * percent_discount / 100 if expect_price >= discount_point
    expect(checkout.total).to equal(expect_price)
  end

  it 'Error when applied mutiple rules for one item' do
    promotion_rules = [
      LogivanTest::DiscountByAmountSpecificItemRule.new(
        apply_code: apply_code, amount_items: 1, discount_price: discount_price
      ),
      LogivanTest::DiscountByAmountSpecificItemRule.new(
        apply_code: apply_code, amount_items: 1, discount_price: discount_price
      )
    ]
    expect{LogivanTest::Checkout.new(promotion_rules)}.to raise_error('Error: Cannot applied mutiple rules for 1 item code')
  end
end
