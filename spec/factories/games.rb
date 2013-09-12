FactoryGirl.define do
  factory :game do
    name {Forgery::LoremIpsum.words(3)}
    location {Forgery::LoremIpsum.words(3)}
    start_time {Time.now + 1.week}
  end
end
