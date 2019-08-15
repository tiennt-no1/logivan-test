# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require_relative './rule'
module LogivanTest
  class Checkout
    def initialize(rules)
      raise 'Error: rules cannot empty!' if rules.blank?

      apply_code_hash = {}

      rules.each do |rule|
        raise 'Error: invalid input promotion rule!' unless rule.is_a? Rule
        raise 'Error: Cannot applied mutiple rules for 1 item code' if apply_code_hash[rule.apply_code] && rule.apply_code != :all

        apply_code_hash[rule.apply_code] = true
      end

      @rules = rules
      @items = []
      @rules_priority = false
    end
    attr_accessor :items, :rules
    attr_writer :rules_priority

    def scan(item)
      raise 'Error: cannot scan invalid item!' unless item.is_a? Item

      @items << item
    end

    def clear_items
      @items = []
    end

    def rules_priority?
      @rules_priority
    end

    def total
      total_price = @items.inject(0) { |sum, item| sum += item.price }
      total_discount = @rules.inject(0) do |sum_total_discount, rule|
        rule.items = @items
        if sum_total_discount.positive? && @rules_priority && rule.apply_code == :all

          current_total = total_price - sum_total_discount
          rule.amount_discountable = current_total
        end
        rule.calculate_discount
        sum_total_discount += rule.total_discount
      end
      (total_price - total_discount).round(2)
    end

    def detail
      @items.each do |item|
        puts "#{item.code} - #{item.name} : #{item.price}"
      end
      puts 'Discount'
      @rules.each do |rule|
        puts "#{rule.name} : #{rule.total_discount}"
      end
      puts '-------------------'
      puts "Total: #{total}"
    end
  end
end
