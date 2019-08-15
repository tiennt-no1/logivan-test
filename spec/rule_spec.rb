# frozen_string_literal: true

require 'rspec'
require_relative '../lib/rule.rb'
require_relative './spec_helper.rb'

RSpec.describe LogivanTest::Rule do
  it_behaves_like 'promotion_rule'
end
