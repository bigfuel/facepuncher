Fabricator(:signup) do
  email      { Faker::Internet.email }
  first_name { Faker::Name.first_name }
  last_name  { Faker::Name.last_name }
  zip_code   { Faker::Address.zip_code }
  project
end