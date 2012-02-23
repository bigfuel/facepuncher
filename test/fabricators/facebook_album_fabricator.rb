Fabricator(:facebook_album) do
  name      { Faker::Lorem.name }
  set_id    000000000000000 # change this to a real album set id
  project
end