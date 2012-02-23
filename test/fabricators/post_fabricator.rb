Fabricator(:post) do
  title     { Faker::Lorem.sentence }
  content   { Faker::Lorem.paragraph }
  url       "http://www.google.com"
  image     ""
  project
end