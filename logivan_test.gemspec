# frozen_string_literal: true

require 'rubygems'

Gem::Specification.new do |s|
  s.name = 'logivan-test'
  s.author = 'Thanh Tien'
  s.version = '0.0.0'
  s.summary = 'for interview test'
  s.files =  Dir['lib/*']
  s.files =  Dir['rspec/*']
  s.require_paths = %w[lib rspec]
  s.add_dependency 'activesupport', '~> 5.0'
  s.add_dependency 'faker', '~> 2.1.2'
  s.add_dependency 'rspec', '~> 3.8.0'
  s.add_dependency 'rspec-benchmark', '~> 0.5.0'
end
