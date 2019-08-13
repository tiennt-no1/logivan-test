
require 'rspec'
require 'faker'
require_relative "../lib/rule.rb"

RSpec.describe LogivanTest::Rule do
    
    it "test default options of rule" do
        rule = LogivanTest::Rule.new
        expect(rule.total_discount).to eq 0
        expect(rule.percent_discount).to eq 0
        expect(rule.price_discount).to eq 0
        expect(rule.code_apply).to eq :all
    end

end