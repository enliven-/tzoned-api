FactoryGirl.define do
  factory :timezone do
    name            { Faker::Name.name }
    city            { Faker::Address.city }
    abbr            { ('A'..'Z').to_a.sample + 'ST : ' + (1..300).to_a.sample.to_s }
    gmt_difference  { (0..3).step(0.5).to_a.sample * 60 * 60 }
    user_id         { (1..3).to_a.sample }
  end

end
