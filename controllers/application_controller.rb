require 'sinatra/base'
require 'sinatra/reloader'

require_relative '../services/redis_pool'

class ApplicationController < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  configure :development do
    register Sinatra::Reloader
  end

  before { content_type :json }

  def redis
    RedisPool.instance
  end

  def file_reader
    FileReaderPool.instance
  end
end
