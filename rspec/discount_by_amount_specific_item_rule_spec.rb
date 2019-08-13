
require 'rspec'
require_relative "../lib/rules/discount_by_amount_specific_item_rule.rb"
require_relative "./spec_helper.rb"

RSpec.describe LogivanTest::DiscountByAmountSpecificItemRule do
    it_behaves_like 'promotion_rule'
end