# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
      player_number  {Random.rand(100)}
      team
      user
  end
end
