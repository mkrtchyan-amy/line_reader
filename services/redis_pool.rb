require 'redis'
require 'connection_pool'
require 'singleton'

class RedisPool
  include Singleton

  attr_reader :pool

  def initialize
    pool_size = ENV.fetch('REDIS_POOL_SIZE', 10).to_i
    timeout = ENV.fetch('REDIS_TIMEOUT', 5).to_i

    @pool = ConnectionPool.new(size: pool_size, timeout: timeout) do
      Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379')
    end
  end

  def set(key, value, **options)
    @pool.with do |conn|
      conn.set(key, value, **options)
    end
  end

  def get(key)
    @pool.with do |conn|
      conn.get(key)
    end
  end

  def shutdown
    @pool.shutdown { |c| c.close }
  end
end
