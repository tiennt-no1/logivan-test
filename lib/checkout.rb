# frozen_string_literal: true

module LogivanTest
  class Checkout
    def initialize(rules)
      raise 'Error: rules cannot empty!' if rules.blank?

      @rules = rules
      @items = []
    end

    def scan(item)
      raise 'Error: rules cannot empty!' if item.class != LogivanTest::Item

      @items.add(item)
    end

    def total
      total_price = @items.inject(0) { |sum| sum += item.price }
      total_discount = @rules.inject(0) { |sum, rule| rule.calculate_discount; sum += rule.total_discount }
      total_price - total_discount
    end
  end
end
