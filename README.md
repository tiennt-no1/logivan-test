# How to install
Add this line to Gemfile:
```ruby
gem 'logivan-test', git: 'https://github.com/tiennt-no1/logivan-test'
```
then run `bundle install`

# Require on code
```ruby 
require 'logivan-test'
```

# Example
```ruby
# each item have code, name and price
# we can add one item more than one time by scan
item_data = [
  { code: '001', name: 'Lavender heart', price: 9.25 },
  { code: '001', name: 'Lavender heart', price:  9.25 },
  { code: '002', name: 'Personalised cufflinks', price: 45.00 },
  { code: '003', name: 'Kids T-shirt', price: 19.95 }
]
# rule or promotion rule will decide how much customer will be discount to incentive for customer

# DiscountByAmountSpecificItemRule
#  if client buy euqual or more amount item which have apply code, they can buy with discount_price
#  discount_price <= normal price of item
rule1 = LogivanTest::DiscountByAmountSpecificItemRule.new(apply_code: '001', amount_items: 2, discount_price: 8.50)

# DiscountByTotalPriceRule
rule2 = LogivanTest::DiscountByTotalPriceRule.new(discount_point: 60, percent_discount: 10)
# if the client purchase more or equal than discount point they will be descount 10%

checkout = LogivanTest::Checkout.new([rule1,rule2])
item_data.each do |data|
  item = LogivanTest::Item.new(data)
  checkout.scan item
end

# the total money they have to pay 
checkout.total
# 73.61
# Detail:
# 001 : 9.25
# 001 : 9.25
# 002 : 45.00
# 003 : 19.95
# ----------------
# toal : 83.45 - 8.34 - (9.25 - 8.5)*2 = 73.61

# we see the rule2(discount 10%) is apply based on total, but if you want to apply when finish rule 1. we can use
checkout.rules_priority = true
checkout.total
# 73.76
# Detail: 
# 001 : 9.25
# 001 : 9.25
# 002 : 45.00
# 003 : 19.95
# ----------------
# toal : 83.45 - (9.25 - 8.5)*2 = 81.95 - 8.19 = 73.76
```

## Other options for the promotion rule:
* percent_discount, default is 0
* discount_price, default is 0
calculate discount based on percen (eg: 10%) or discount_price (eg: from 9.25 to 8.5), just use 1 setting for 1 rule
* apply_code : the code will apply discount, default is :all
* amount_items: use on DiscountByAmountSpecificItemRule, discount will applied if buy more or equal than amount_item
* discount_point: use on DiscountByTotalPriceRule, discount will applied if total money >= discount_point
