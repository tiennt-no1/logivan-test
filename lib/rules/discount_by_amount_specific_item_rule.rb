# frozen_string_literal: true

require_relative '../rule.rb'
module LogivanTest
  class DiscountByAmountSpecificItemRule < Rule
    def initialize(options = { apply_code: nil, amount_items: 0 })
      super
      @name = 'Discount on specific item'
      @amount_items = options[:amount_items]
      @apply_code = options[:apply_code]
    end
    attr_accessor :apply_code, :amount_items

    def discountable?
      applied_items.length >= amount_items && amount_items.positive?
    end
  end
end
