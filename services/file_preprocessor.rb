require_relative '../services/redis_pool'

module FilePreprocessor
  # Indexes the file by storing the byte offsets of each line in Redis.
  # @param file_path [String] Path to the file to be indexed.
  def self.index_file_offsets(file_path)
    redis = RedisPool.instance

    offset = 0
    line_number = 1

    IO.foreach(file_path) do |line|
      redis.set("line_offset:#{line_number}", offset)
      offset += line.bytesize
      line_number += 1
    end

    redis.set('total_lines', line_number)
  end
end
