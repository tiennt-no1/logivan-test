# frozen_string_literal: true

require 'rspec'
require 'faker'
require 'rspec-benchmark'
require_relative '../lib/item.rb'

module Helpers
  def create_item
    params = {
      code: Faker::Number.number(digits: 3).to_s,
      name: Faker::FunnyName.name,
      price: Faker::Number.decimal(l_digits: 2)
    }
    LogivanTest::Item.new params
  end
end

RSpec.configure do |c|
  c.include Helpers
  c.include RSpec::Benchmark::Matchers
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
end
