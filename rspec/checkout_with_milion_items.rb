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

RSpec.describe LogivanTest::Checkout do
    let (:discount_price) { 60.0 }
    let (:item_price) { 70.0 }
    let (:discount_point) { 70.0 }
    let (:apply_code) { '001' }
    let (:apply_code2) { '002' }
    let (:unapply_code) { '003' }
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
    
  
  end  