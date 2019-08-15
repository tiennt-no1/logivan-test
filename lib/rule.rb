# frozen_string_literal: true

module LogivanTest
  class Rule
    def initialize(options = {})
      # set default attributes
      @total_discount = options[:total_discount] || 0
      @percent_discount = options[:percent_discount] || 0
      @discount_price = options[:discount_price] || 0
      @apply_code = options[:apply_code] || :all
      @items = []
    end
    attr_accessor :total_discount, :percent_discount, :discount_price, :apply_code, :items

    def discountable?
      false
    end

    def applied_items
      if @apply_code == :all
        @items
      else
        items.select { |item| item.code == @apply_code }
      end
    end

    def amount_discountable
      applied_items.inject(0) { |sum, item| sum += item.price }
    end

    def calculate_discount
      if !discountable? || applied_items.empty?
        @total_discount = 0
        return
      end

      item_price = applied_items.first.price

      @total_discount =
        if discount_price.positive?
          raise 'Error: The price of discount have to smaller than common price' if discount_price > item_price

          # pick default first applied item to get price
          applied_items.length * (item_price - discount_price)
        elsif percent_discount.positive?
          amount_discountable * percent_discount / 100
        else
          0
        end
    end
  end
end
