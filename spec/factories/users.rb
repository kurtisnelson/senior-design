# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name {Forgery::Name.full_name}
    email {Forgery::Internet.email_address}
    factory :user_with_team do
        association :team
    end
  end
end
