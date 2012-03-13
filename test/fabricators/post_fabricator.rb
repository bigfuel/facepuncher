Fabricator(:post) do
  title     { Faker::Lorem.sentence }
  content   { Faker::Lorem.paragraph }
  url       "http://www.google.com"
  image     File.open(Rails.root.join('test', 'support', 'Desktop.jpg'))
  project
end