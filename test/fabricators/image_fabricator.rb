Fabricator(:image) do
  image File.open(Rails.root.join('test', 'support', 'Desktop.jpg'))
  project
end