require 'rubygems'

Gem::Specification.new do |s|
  s.name = %q{logivan-test}
  s.author = "Thanh Tien"
  s.version = "0.0.0"
  s.summary = %q{for interview test}
  s.files = [
    "lib/checkout.rb",
    "lib/item.rb",
    "lib/rule.rb"

  ]
  s.require_paths = ["lib"]
  s.add_dependency "rspec", "3.4.0"
end
