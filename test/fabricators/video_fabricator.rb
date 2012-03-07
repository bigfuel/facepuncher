Fabricator(:video) do
  youtube_id { Faker::Product.letters(12) }
  screencap  { Rack::Test::UploadedFile.new(Rails.root.join('test', 'support', 'Desktop.jpg').to_s, 'image/jpeg', true) }
  project
end
