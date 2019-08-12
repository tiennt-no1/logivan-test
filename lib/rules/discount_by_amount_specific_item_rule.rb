module LogivanTest
    class DiscountByAmountSpecificItemRule < Rule

        def initialize({code_apply: nil, amount_items: 0})
            super
            @amount_items = amount_items
        end
        
        def discountable?
            applied_items.length >= amount_items
        end
    end
end
  