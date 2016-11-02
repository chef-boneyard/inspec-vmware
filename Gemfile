# encoding: utf-8
source 'https://rubygems.org'

# pin dependency for Ruby 1.9.3 since bundler is not
# detecting that net-ssh 3 does not work with 1.9.3
if Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('1.9.3')
  gem 'net-ssh', '~> 2.9'
end

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.2.2')
  gem 'json', '~> 1.8'
  gem 'rack', '< 2.0'
end

group :inspec do
  gem 'inspec', '~> 1.1'
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
