require 'globalid-utils'
require 'pry'

Dir[File.expand_path(File.join('../support', '**', '*.rb'), __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
