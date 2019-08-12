module LogivanTest
    class Item
        attr_accessor :code, :name, :price
        def initialize (params = {})
            params = params.inject({}) do |symbolize_hash, (key, value)| 
                symbolize_hash[key.to_sym] = value 
                symbolize_hash
            end
            @code = params[:code]
            @name = params[:name]
            @price = params[:price]
        end

        def valid?
            @code.present? && @name.present? && @price.present?
        end
    end
end
  