module LogivanTest
    class DiscountByTotalPriceRule < Rule

        def initialize({discount_point: nil})
            super
            @discount_point = discount_point
        end
        
        def discountable?
            ammount_discountable > discount_point
        end
    end
end
  