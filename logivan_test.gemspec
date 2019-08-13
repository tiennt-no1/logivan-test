# frozen_string_literal: true

require 'rubygems'

Gem::Specification.new do |s|
  s.name = 'logivan-test'
  s.author = 'Thanh Tien'
  s.version = '0.0.0'
  s.summary = 'for interview test'
  s.files = [
    'lib/checkout.rb',
    'lib/item.rb',
    'lib/rule.rb'

  ]
  s.require_paths = ['lib']
  s.add_dependency 'rspec', '3.4.0'
end
