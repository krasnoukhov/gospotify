require "rake"
require "rake/testtask"

Dir["tasks/*.rake"].each { |f| import f }

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.libs.push "test"
end

desc "Configure environment"
task :environment do
  require_relative "application"
end

namespace :test do
  desc "Run tests & measure coverage"
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["test"].invoke
  end

  desc "Tests combo"
  task combo: [:environment, :"db:drop", :"db:create", :coverage] {}
end

task default: :"test:combo"
