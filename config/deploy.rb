require "mina/bundler"
require "mina/git"
require "mina/rvm"

set :domain, "gospotify.me"
set :deploy_to, "/home/gospotify/www"
set :repository, "git://github.com/krasnoukhov/gospotify.git"
set :branch, "master"
set :user, "gospotify"

task :environment do
  invoke "rvm:use[#{`cat .ruby-version`.strip}@#{`cat .ruby-gemset`.strip}]"
end

desc "Deploys the current version to the server."
task deploy: :environment do
  deploy do
    invoke "git:clone"
    invoke "bundle:install"

    to :launch do
      queue "/etc/init.d/railsweb gospotify reload"
      queue "sudo /etc/init.d/gospotify-sidekiq restart"
    end
  end
end
