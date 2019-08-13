# frozen_string_literal: true

module LogivanTest
  class Rule
    def initialize(options = {})
      # set default attributes
      @total_discount = options[:total_discount] || 0
      @percent_discount = options[:percent_discount] || 0
      @price_discount = options[:price_discount] || 0
      @code_apply = options[:code_apply] || :all
      @items = []
    end
    attr_accessor :total_discount, :percent_discount, :price_discount, :code_apply, :items

    def discountable?
      false
    end

    def applied_items
      if @code_apply == :all
        @items
      else
        items.map { |item| item.code == @code_apply }
      end
    end

    def ammount_discountable
      applied_items.inject(0) { |sum, item| sum += item.price }
    end

    def calculate_discount
      return unless discountable?
      return if applied_items.empty?

      @total_discount =
        if price_discount
          applied_items.length * (applied_items.first.price - price_discount)
        elsif percent_discount
          ammount_discountable * percent_discount / 100
          end
    end
  end
end
