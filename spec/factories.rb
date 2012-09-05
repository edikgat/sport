# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user,  aliases: [:sender, :receiver] do
    first_name "Test"
    last_name "User"
    birth_date (Date.today - 20.years)
    sequence(:email) {|n| "person#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end


  # Defines a new sequence

  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :name do |n|
    "Person #{n}"
  end


factory :micropost do
  user
  content "Foo bar"
  
end

factory :message do
  
  association :sender, factory: :user
  association :receiver, factory: :user
  content "Foo bar?"
  
end





end