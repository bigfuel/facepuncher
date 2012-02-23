raise "Seeding production is not allowed." if Rails.env.production?

# admins
users = [
  {email: "admin@example.com", password: "password", password_confirmation: "password"},
]

users.each { |u| User.create!(u) }