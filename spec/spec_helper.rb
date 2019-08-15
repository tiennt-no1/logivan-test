# frozen_string_literal: true

require 'rspec'
require 'faker'
require_relative '../lib/item.rb'

module Helpers
  def create_item(code = nil, price = nil)
    params = {
      code: code ||Faker::Number.number(digits: 3).to_s,
      name: Faker::FunnyName.name,
      price: price || Faker::Number.decimal(l_digits: 2)
    }
    LogivanTest::Item.new params
  end
end

RSpec.configure do |c|
  c.include Helpers
end

shared_examples_for 'promotion_rule' do
  it 'test default options of rule' do
    rule = described_class.new
    expect(rule.total_discount).to eq 0
    expect(rule.percent_discount).to eq 0
    expect(rule.discount_price).to eq 0
    expect(rule.discountable?).to be false
    expect(rule.amount_discountable).to eq 0
    expect(rule.total_discount).to eq 0

    rule.calculate_discount
    expect(rule.total_discount).to eq 0
  end

  it 'raise error when set both percent_discount and discount_price' do
    expect { described_class.new(discount_price: 10, percent_discount: 10) }.to raise_error('Error: Cannot combine percent_discount and discount_price option')
  end
end
