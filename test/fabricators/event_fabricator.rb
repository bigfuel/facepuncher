Fabricator(:event) do
  name       { Faker::Lorem.sentence }
  start_date { 1.day.from_now }
  end_date   { 2.days.from_now }
  project
end