FactoryBot.define do
  factory :payment do
    user { nil }
    profile { nil }
    amount { 1 }
  end
end
