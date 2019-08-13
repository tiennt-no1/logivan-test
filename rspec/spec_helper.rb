# frozen_string_literal: true

require 'rspec'

shared_examples_for 'promotion_rule' do
  it 'test default options of rule' do
    rule = described_class.new
    expect(rule.total_discount).to eq 0
    expect(rule.percent_discount).to eq 0
    expect(rule.discount_price).to eq 0
    expect(rule.discountable?).to be false
    expect(rule.ammount_discountable).to eq 0
    expect(rule.total_discount).to eq 0

    rule.calculate_discount
    expect(rule.total_discount).to eq 0
  end
end
