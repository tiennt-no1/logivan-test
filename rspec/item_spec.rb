
require 'rspec'
require 'faker'
require_relative "../lib/item.rb"

create_item = -> {
    params = {
        code: Faker::Number.number(digits: 3).to_s,
        name: Faker::FunnyName.name ,
        price: Faker::Number.decimal(l_digits: 2),
    }
    LogivanTest::Item.new params
}

RSpec.describe LogivanTest::Item do
    it "create empty item" do
        item = LogivanTest::Item.new
        expect(item.code).to be_nil
        expect(item.name).to be_nil
        expect(item.price).to be_nil
    end

    it "create unempty item" do
        item = create_item.call
        expect(item.code).to_not be_nil
        expect(item.name).to_not be_nil
        expect(item.price).to_not be_nil
    end

    it "test valid of item" do
        empty_item = LogivanTest::Item.new
        expect(empty_item.valid?).to be false

        item= create_item.call
        expect(item.valid?).to be true
        item.name = nil
        expect(item.valid?).to be false


        item= create_item.call
        expect(item.valid?).to be true
        item.code = nil
        expect(item.valid?).to be false


        item= create_item.call
        expect(item.valid?).to be true
        item.price = nil
        expect(item.valid?).to be false
    end


  end