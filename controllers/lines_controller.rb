require_relative 'application_controller'
require_relative '../services/file_reader_pool'

class LinesController < ApplicationController

  get '/lines/:id' do
    line_index = params[:id].to_i

    validate_index(line_index)

    line_offset = redis.get("line_offset:#{line_index}").to_i

    line = file_reader.read_line(line_offset)
    json_response(200, line: line.chomp)
  end

  private

  def total_lines
    @total_lines ||= redis.get('total_lines').to_i
  end

  def validate_index(index)
    if index >= total_lines || index <= 0
      json_response(413, error: 'Requested line is beyond the end of the file.')
    end
  end

  def json_response(status_code, data = {})
    halt status_code, data.to_json
  end
end
