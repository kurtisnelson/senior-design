# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stat do
    at_bats 1
    hits 1
    rbis 1
    singles 1
    doubles 1
    triples 1
    home_runs 1
    strike_outs 1
    walks 1
  end
end
