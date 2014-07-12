fake_dynamo: BUNDLE_GEMFILE=Fakefile bundle exec fake_dynamo -l debug -d tmp/fake.db
jsx: jsx --watch -x jsx app/jsx/ public/
worker: sidekiq -r ./config/applications.rb
web: bundle exec puma -C config/puma.rb
console: bundle exec lotus console
