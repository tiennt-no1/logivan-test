# frozen_string_literal: true

require 'rspec'
require_relative '../lib/checkout.rb'
require_relative './spec_helper.rb'

RSpec.describe LogivanTest::Checkout do
  it 'invalid init checkout' do
    expect { LogivanTest::Checkout.new }.to raise_error(ArgumentError)
    expect { LogivanTest::Checkout.new([]) }.to raise_error('Error: rules cannot empty!')
    expect { LogivanTest::Checkout.new([1, 2, 3]) }.to raise_error('Error: invalid input promotion rule!')
  end
end
