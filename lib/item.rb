# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

module LogivanTest
  class Item
    attr_accessor :code, :name, :price
    def initialize(params = {})
      params = params.each_with_object({}) do |(key, value), symbolize_hash|
        symbolize_hash[key.to_sym] = value
      end
      @code = params[:code]
      @name = params[:name]
      @price = params[:price]
    end

    def valid?
      code.present? && name.present? && price.present?
    end
  end
end
