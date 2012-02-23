Fabricator(:view_template) do
  contents { Faker::Lorem.sentence }
  path     'fp_test/index'
  formats  'html'
  locale   'en'
  handlers 'haml'
  project
end