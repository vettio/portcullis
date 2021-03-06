require 'database_cleaner'

RSpec.configure do | config |
  DatabaseCleaner.logger = Rails.logger

  config.before(:suite) do | suite |
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do | run |
    turnip = run.example.metadata[:turnip]
    DatabaseCleaner.start unless turnip == true
  end

  config.after(:each) do | example |
    turnip = example.example.metadata[:turnip]
    DatabaseCleaner.clean unless turnip == true
  end
end if defined?(DatabaseCleaner)
