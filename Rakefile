require 'rake'
require 'dotenv/tasks'
require_relative './services/file_preprocessor'

task create_file: :dotenv do
  file_path = ENV['FILE_PATH']
  line_count = 1_000_000

  puts "Generating file at #{file_path} with #{line_count} lines..."
  File.open(file_path, 'w') do |file|
    line_count.to_i.times do |i|
      file.puts("This is line number #{i + 1}")
    end
  end
  puts 'File generated successfully.'
end

task preprocess_file: :dotenv do
  puts "Indexing file lines' offsets..."
  FilePreprocessor.index_file_offsets(ENV['FILE_PATH'])
  puts 'File lines indexed successfully.'
end
