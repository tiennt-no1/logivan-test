# frozen_string_literal: true

require 'rspec'
require_relative '../lib/checkout.rb'
require_relative '../lib/rule.rb'
require_relative '../lib/item.rb'
require_relative './spec_helper.rb'

RSpec.describe LogivanTest::Checkout do
  it 'invalid init checkout' do
    expect { LogivanTest::Checkout.new }.to raise_error(ArgumentError)
    expect { LogivanTest::Checkout.new([]) }.to raise_error('Error: rules cannot empty!')
    expect { LogivanTest::Checkout.new([1, 2, 3]) }.to raise_error('Error: invalid input promotion rule!')
  end

  it 'invalid input scan item' do
    rule1= LogivanTest::Rule.new
    rule2= LogivanTest::Rule.new
    checkout = LogivanTest::Checkout.new([rule1, rule2])
    expect { checkout.scan}.to raise_error(ArgumentError)
    expect { checkout.scan(1) }.to raise_error('Error: cannot scan invalid item!')
    expect { checkout.scan({}) }.to raise_error('Error: cannot scan invalid item!')
  end
end
