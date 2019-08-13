# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require_relative './rule'
module LogivanTest
  class Checkout
    def initialize(rules)
      raise 'Error: rules cannot empty!' if rules.blank?

      rules.each do |rule|
        raise 'Error: invalid input promotion rule!' unless rule.is_a? Rule
      end

      @rules = rules
      @items = []
    end

    def scan(item)
      raise 'Error: cannot scan invalid item!' unless item.is_a? Item
      @items << item
    end

    def total
      total_price = @items.inject(0) { |sum, item| sum += item.price }
      total_discount = @rules.inject(0) do |sum, rule| 
        rule.items =  @items
        rule.calculate_discount; sum += rule.total_discount 
      end
      total_price - total_discount
    end
  end
end
