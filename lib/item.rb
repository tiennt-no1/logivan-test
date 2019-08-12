module LogivanTest
    class Item
        attr_accessor :code, :name, :price
        def initialize(code =nil , name =nil , price = nil)
            @code = code
            @name = name
            @price = price
        end
    end
end
  