FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    name { "John Doe" }
    email
    password { SecureRandom.hex }
    role { "user" }
    email_confirmed_at { 1.hour.ago }
    terms_accepted_at { 1.hour.ago }
  end
end
