# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Simpkins"
    email {Forgery::Internet.email_address}
    uid 1
    factory :user_with_team do
        association :team
    end
  end
end
