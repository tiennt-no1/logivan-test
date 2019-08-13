require_relative "../rule.rb"
module LogivanTest
    class DiscountByTotalPriceRule < Rule

        def initialize(options = {discount_point: 0})
            super
            @discount_point = options[:discount_point]
        end
        attr_accessor :discount_point
        
        def discountable?
            ammount_discountable >= discount_point && discount_point > 0
        end
    end
end
  