# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'minitest' do
  watch(%r{^lib/(.+)\.rb$})                          { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch('test/minitest_helper.rb')                       { "test" }

  # Rails example
  watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r{^app/views/.+\.rb$})                      { "test/integration" }
  watch(%r{^test/fabricators/(.+)_fabricator\.rb$})  { |m| "test/unit/#{m[1]}_test.rb" }
  watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
end