source 'https://rubygems.org'


gem 'rails'
gem 'rails-api', '0.4.0'
gem 'devise'
gem 'active_model_serializers'
gem 'rack-cors', :require => 'rack/cors'
gem 'cancancan', '~> 1.10'

group :production do
  gem 'pg'
end

group :development do
  gem 'spring'
  gem 'sqlite3'
end


group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'shoulda-matchers', '~> 3.0'
end