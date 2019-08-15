# frozen_string_literal: true

require 'item.rb'
require 'checkout.rb'
require 'rule.rb'
module LogivanTest
  autoload :Item, './item.rb'
  autoload :Checkout, './checkout.rb'
  autoload :Rule, './rule.rb'
  autoload :DiscountByAmountSpecificItemRule, './rules/discount_by_amount_specific_item_rule.rb'
  autoload :DiscountByTotalPriceRule, './rules/discount_by_total_price_rule.rb'
end
