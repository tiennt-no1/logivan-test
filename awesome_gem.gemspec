require 'rubygems'

Gem::Specification.new do |s|
  s.name = %q{logivan-test}
  s.author = "Thanh Tien"
  s.version = "0.0.0"
  s.date = %q{12-8-2019}
  s.summary = %q{for interview test}
  s.files = [
    "lib/awesome_gem.rb",
    "lib/item.rb",
    "lib/rule.rb"

  ]
  s.require_paths = ["lib"]
  s.add_dependency "rspec", version
end
