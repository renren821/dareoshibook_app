FactoryBot.define do
  factory :post do
    name { "MyString" }
    author { "MyString" }
    celebrity { "MyString" }
    introduction { "MyText" }
    reference { "MyText" }
    user { nil }
  end
end
