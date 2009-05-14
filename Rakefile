desc "Run all the tests for the orchestra library"
task :test do
  cmd = "bacon #{Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].join(' ')}"
  puts `#{cmd}`
end
