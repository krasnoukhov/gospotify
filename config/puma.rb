workers Integer(ENV['PUMA_WORKERS'] || 1)
threads Integer(ENV['PUMA_MIN_THREADS']  || 1), Integer(ENV['PUMA_MAX_THREADS'] || 1)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']      || 2300
environment ENV['LOTUS_ENV'] || 'development'
