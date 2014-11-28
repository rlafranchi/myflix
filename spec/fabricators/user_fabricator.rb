Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  name { Faker::Name.name }
  customer_token 'abcdefg'
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
