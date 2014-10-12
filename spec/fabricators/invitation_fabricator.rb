Fabricator(:invitation) do
  email { Faker::Internet.email }
  message { Faker::Lorem.paragraph(2) }
  name { Faker::Name.name }
end
