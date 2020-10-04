FactoryBot.define do
  factory :user do
    name { "Example" }
    sequence(:email) { |i| "test#{i}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
