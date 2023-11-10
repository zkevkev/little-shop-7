require 'faker'

FactoryBot.define do
  factory :discount do
    percentage_discount { Faker::Number.between(from: 0.0, to: 0.8) } 
    quantity_threshold { rand(5..20) } 
    association :merchant
  end
end