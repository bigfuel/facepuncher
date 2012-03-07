Fabricator(:image) do
  image   { Rack::Test::UploadedFile.new(Rails.root.join('test', 'support', 'Desktop.jpg').to_s, 'image/jpeg', true) }
  project
end