Fabricator(:location) do
  name      { Faker::Name.name }
  address   { Faker::Address.street_address }
  latitude  40.742264
  longitude(-73.9913408)
end