Fabricator(:video) do
  name { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.words(5).join("") }
end
