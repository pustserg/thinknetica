FactoryGirl.define do

  sequence :email do |n|
    "testuser-#{n}@think.test"
  end

  factory :user do
    email
    password 'testpassword'
    password_confirmation 'testpassword'
  end

end
