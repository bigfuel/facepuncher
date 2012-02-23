Fabricator(:video) do
  youtube_id { Faker::Product.letters(12) }
  screencap  File.open(Rails.root.join('test', 'support', 'Desktop.jpg'))
  project
end
