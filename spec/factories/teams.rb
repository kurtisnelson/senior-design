# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :team do
    name {Forgery::Personal.shirt_size}
    description {Forgery::LoremIpsum.words(1)}
  end
end
