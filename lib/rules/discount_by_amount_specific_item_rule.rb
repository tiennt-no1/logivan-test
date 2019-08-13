module LogivanTest
    class DiscountByAmountSpecificItemRule < Rule

        def initialize({code_apply: nil, amount_items: 0})
            super
            throw "Error: amount item must be greater than 0" if @amount_items <= 0 
            @amount_items = amount_items
        end
        
        def discountable?
            applied_items.length >= amount_items
        end
    end
end
  