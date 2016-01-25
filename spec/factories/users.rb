FactoryGirl.define do

  factory :user do
    email                 { Faker::Internet.email }
    password              'mypassword'
    password_confirmation 'mypassword'
    role                  :regular
  end

  factory :manager, class: User do
    email                 { Faker::Internet.email }
    password              'mypassword'
    password_confirmation 'mypassword'
    role                  :manager
  end

  factory :admin, class: User do
    email                 { Faker::Internet.email }
    password              'mypassword'
    password_confirmation 'mypassword'
    role                  :admin
  end

  factory :invalid_user, class: User do
    email                 'some.come'
    password              'mypassword'
    password_confirmation 'password'
    role                  :regular
  end

end
