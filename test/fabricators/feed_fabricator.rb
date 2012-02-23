Fabricator(:feed) do
  name    { Faker::Name.first_name }
  url     "http://c2c.bigfuel.com/feed/"
  limit   10
  project
end