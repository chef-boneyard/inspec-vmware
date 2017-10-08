# encoding: utf-8
source 'https://rubygems.org'

group :inspec do
  gem 'inspec', '~> 1.1'
  gem 'rbvmomi'
end

group :test do
  gem 'bundler', '~> 1.5'
  gem 'minitest', '~> 5.5'
  gem 'rake', '~> 10'
  gem 'rubocop', '~> 0.44.0'
  gem 'simplecov', '~> 0.10'
end

group :integration do
  gem 'berkshelf', '~> 4.0'
  gem 'test-kitchen'
  gem 'kitchen-vagrant'
  gem 'kitchen-ec2'
  gem 'kitchen-inspec'
end

group :tools do
  gem 'github_changelog_generator', '~> 1.12.0'
end
