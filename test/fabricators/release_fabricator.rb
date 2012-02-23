Fabricator(:release) do
  description { Faker::Lorem.sentence }
  live_date   Time.current + 1.day
  branch      "master"
  project
end