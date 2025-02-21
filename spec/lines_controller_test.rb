require 'spec_helper'
require_relative '../controllers/lines_controller'

RSpec.describe LinesController do
  def app
    LinesController
  end

  it 'returns a valid line for an existing index' do
    get '/lines/1'
    expect(last_response).to be_ok
    expect(last_response.body).to include('line')
  end
  [-1, 1_000_001].each do |invalid_index|
    it 'returns 413 for a line beyond the end of the file' do
      get "/lines/#{invalid_index}"

      expect(last_response.status).to eq 413
      expect(json_response[:error]).to eq('Requested line is beyond the end of the file.')
    end
  end
end
