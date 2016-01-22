FactoryGirl.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              'mypassword'
    password_confirmation 'mypassword'
    role                  { [:regular, :manager, :admin].sample }
  end
end
