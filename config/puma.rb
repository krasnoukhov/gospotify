workers Integer(ENV['PUMA_WORKERS'] || 1)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 1)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']      || 2300
environment ENV['LOTUS_ENV'] || 'development'

if ENV['SIDEKIQ_THREADS']
  on_worker_boot do
    spawn("bundle exec sidekiq -r ./config/applications.rb -c #{ENV['SIDEKIQ_THREADS'] || 1}")
  end
end
