# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'cancan/matchers'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
Dir[Rails.root.join('spec', 'shared_examples', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  RSpec::Matchers.define_negated_matcher :not_change, :change
  # FactoryBot.create(...) => create(...) |new|create_list|...
  config.include FactoryBot::Syntax::Methods
  # Add Devise helpers for controllers testing
  config.include Devise::Test::ControllerHelpers, type: :controller
  # Add ControllerHelpers module for controllers testing
  config.include ControllerHelpers, type: :controller
  # Add ControllerHelpers module for controllers testing
  config.include FeatureHelpers, type: :feature
  # Add FeatureHelpers module for OmniAuth testing
  config.include OmniauthHelper
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.include ActiveStorageHelpers
  # Add ApiHelpers module for request testing
  config.include ApiHelpers, type: :request

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  Capybara.javascript_driver = :selenium_chrome_headless
  Capybara.default_max_wait_time = 4

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.after(:all) do
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end
end

OmniAuth.config.test_mode = true

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
