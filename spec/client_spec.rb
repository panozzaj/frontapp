require 'spec_helper'
require 'frontapp'

RSpec.describe 'client' do
  describe 'error-handling' do
    let(:frontapp) { Frontapp::Client.new(auth_token: auth_token) }

    it 'handles standard JSON errors' do
      stub_request(:get, "#{base_url}/testing")
        .with(headers: headers)
        .to_return(status: 400, body: { error: 'Some error' }.to_json)
      expect do
        frontapp.get('testing')
      end.to raise_error(Faraday::BadRequestError)
    end

    it 'handles HTML errors' do
      # If Front gives a 502/504, this often presents as an Nginx-style error
      # with an HTML page. Parsing it as JSON may not work and would give us an
      # opaque error message. Verify that this works OK.
      stub_request(:get, "#{base_url}/testing")
        .with(headers: headers)
        .to_return(status: 502, body: '<html></html>')
      expect do
        frontapp.get('testing')
      end.to raise_error(Faraday::ServerError)
    end
  end
end
