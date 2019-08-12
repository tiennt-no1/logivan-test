
require 'rspec'
require 'yaml'
require_relative "../lib/item.rb"
items_test_data = YAML.load_file('./fixture.yml')

RSpec.describe LogivanTest::Item do
    it "create empty item" do
        item = LogivanTest::Item.new
        expect(item.code).to be_nil
        expect(item.name).to be_nil
        expect(item.price).to be_nil
    end

    it "create unempty item" do
        item = LogivanTest::Item.new(items_test_data.first)
        expect(item.code).to_not be_nil
        expect(item.name).to_not be_nil
        expect(item.price).to_not be_nil
    end


  end