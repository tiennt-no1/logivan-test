# frozen_string_literal: true

require_relative '../rule.rb'
module LogivanTest
  class DiscountByTotalPriceRule < Rule
    def initialize(options = { discount_point: 0 })
      super
      @discount_point = options[:discount_point]
    end
    attr_accessor :discount_point
    attr_writer :amount_discountable

    def amount_discountable
      @amount_discountable || super
    end

    def discountable?
      amount_discountable >= discount_point && discount_point.positive?
    end

    def calculate_discount
      super
    end
  end
end
