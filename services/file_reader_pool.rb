require 'connection_pool'
require 'singleton'

class FileReaderPool
  include Singleton

  attr_reader :pool

  def initialize
    @pool = ConnectionPool.new(size: 5, timeout: 5) do
      File.open(ENV['FILE_PATH'], 'r')
    end

    def read_line(offset)
      @pool.with do |file|
        file.seek(offset)
        file.gets.chomp
      end
    end

    def shutdown
      @pool.shutdown { |c| c.close }
    end
  end
end
