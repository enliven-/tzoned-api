FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              'mypassword'
    password_confirmation 'mypassword'
    role                  { [0, 1, 2].sample }
  end
end
