# frozen_string_literal: true

require 'rspec'
require 'faker'
require_relative '../lib/rules/discount_by_total_price_rule.rb'
require_relative './spec_helper.rb'

RSpec.describe LogivanTest::DiscountByTotalPriceRule do
  it_behaves_like 'promotion_rule'
end
