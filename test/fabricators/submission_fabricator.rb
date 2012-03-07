Fabricator(:submission) do
  facebook_name   { Faker::Internet.user_name }
  facebook_id     { sequence(:facebook_id) { |i| "%015d" % i } }
  facebook_email  { Faker::Internet.email }
  description     { Faker::Lorem.sentence }
  photo           { Rack::Test::UploadedFile.new(Rails.root.join('test', 'support', 'Desktop.jpg').to_s, 'image/jpeg', true) }
  project
end