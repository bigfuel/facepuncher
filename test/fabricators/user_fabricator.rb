Fabricator(:user) do
  email                 { Faker::Internet.email }
  password              'bfpassword'
  password_confirmation { |u| u.password }
end