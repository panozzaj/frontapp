require "spec_helper"
require "frontapp"

RSpec.describe "Errors" do
  let(:headers) {
    {
      "Accept" => "application/json",
      "Authorization" => "Bearer #{auth_token}",
    }
  }
  let(:frontapp) { Frontapp::Client.new(auth_token: auth_token) }

  it "can raise a bad request error" do
    stub_request(:get, "#{base_url}/contacts/1").
      with(headers: headers).
      to_return(status: 400, body: "{}")

    expect do
      frontapp.get_contact(1)
    end.to raise_error(Faraday::BadRequestError)
  end

  it "can raise a not found error" do
    stub_request(:get, "#{base_url}/contacts/1").
      with(headers: headers).
      to_return(status: 404, body: "{}")

    expect do
      frontapp.get_contact(1)
    end.to raise_error(Faraday::ResourceNotFound)
  end

  it "can raise a conflict error" do
    stub_request(:get, "#{base_url}/contacts/1").
      with(headers: headers).
      to_return(status: 409, body: "{}")

    expect do
      frontapp.get_contact(1)
    end.to raise_error(Faraday::ConflictError)
  end

  it "can raise a too many requests error" do
    stub_request(:get, "#{base_url}/contacts/1").
      with(headers: headers).
      to_return(status: 429, body: "{}")

    expect do
      frontapp.get_contact(1)
    end.to raise_error(Faraday::ClientError)
  end
end
