FactoryGirl.define do
  factory :user do
    first_name "James"
    last_name "Kirk"
    sequence("email") { |n| "jkirk#{n}@enterprise.com" }
    is_admin false
    membership 2
    password "thisIsNotAPassword"
  end
end
