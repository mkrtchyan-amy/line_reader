require './controllers/application_controller'
require './controllers/lines_controller'
require 'dotenv'

Dotenv.load

app = Rack::Builder.new do
  run LinesController
end.to_app

run app

at_exit do
  RedisPool.instance.shutdown
  FileReaderPool.instance.shutdown
end
