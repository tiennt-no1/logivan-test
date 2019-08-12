module LogivanTest
  class Checkout
    def initialize(rules)
      raise "Error: rules cannot empty!" if rules.blank?
      raise "Error: invalid input!" if rules.blank?
      raise "Error: rules cannot empty!" if rules.blank?
      raise "Error: rules cannot empty!" if rules.blank?
    end

    def scan
    end
    
    def total
      @total
    end
  end
end
