Fabricator(:project) do
  name                           { sequence(:project_name) { |i| "project_#{i}" } }
  description                    { Faker::Company.catch_phrase }
  repo                           "https://github.com/bigfuel/bf_project_example.git"
  facebook_app_id                "000000000000" # Replace with a real facebook app id
  facebook_app_secret            "00000000000000000000000000000000" # Replace with a real facebook secret
  google_analytics_tracking_code "whyyoutrackin'me"
  production_url                 "https://apps.facebook.com/bf_project_test/"
  staging_url                    "https://apps.facebook.com/bf_project_test_staging/"
end