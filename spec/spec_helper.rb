ENV['APP_ENV'] = 'test'

require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def json_response
  JSON.parse(last_response.body, symbolize_names: true)
end
