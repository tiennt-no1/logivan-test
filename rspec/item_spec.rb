
require 'rspec'
require 'yaml'
require_relative "../lib/item.rb"
test_data = YAML::load_file(File.join(__dir__, 'fixture.yml'))

RSpec.describe LogivanTest::Item do
    it "create empty item" do
        item = LogivanTest::Item.new
        expect(item.code).to be_nil
        expect(item.name).to be_nil
        expect(item.price).to be_nil
    end

    it "create unempty item" do
        item = LogivanTest::Item.new(test_data['items'].first)
        expect(item.code).to_not be_nil
        expect(item.name).to_not be_nil
        expect(item.price).to_not be_nil
    end


  end