# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Simpkins"
    factory :user_with_team do
        association :team
    end
  end
end
