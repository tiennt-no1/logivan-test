# frozen_string_literal: true

require_relative '../rule.rb'
module LogivanTest
  class DiscountByAmountSpecificItemRule < Rule
    def initialize(options = { code_apply: nil, amount_items: 0 })
      super
      @amount_items = options[:amount_items]
      @code_apply = options[:code_apply]
    end
    attr_accessor :code_apply, :amount_items

    def discountable?
      applied_items.length >= amount_items && amount_items.positive?
    end
  end
end
