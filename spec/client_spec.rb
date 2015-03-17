require 'spec_helper'

describe 'client specification' do
  before do
    Admarkt::Api::Client.setup(
      :client_id => 'abc',
      :client_secret => 'def',
      :redirect_uri => 'http://localhost:8080/oauth2/callback',
      :username => 'john',
      :password => 'topsecret',
      :site => 'https://example.org'
    )
    Admarkt::Api::Client.code = 'sample'
    stub_request(:post, "https://john:topsecret@example.org/accounts/oauth/token").
      with(:body => {"client_id"=>"abc", "client_secret"=>"def", "code"=>"sample", "grant_type"=>"authorization_code", "redirect_uri"=>"http://localhost:8080/oauth2/callback"},
          :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'}).
      to_return(:status => 200, :body => '{ "access_token":"5781def0-bccb-49dd-938d-3b23d664bd0d","token_type":"Bearer","expires_in":43199,"refresh_token":"7a017a3e-b4a2-40cf-8d03-ea7262535653","scope":""}', headers: {'Content-Type' => 'application/json'})

    @client = Admarkt::Api::Client.new
  end

  it 'should use auth_code authorization code strategy to generate authorize_url' do
    expected_url = OAuth2::Client.new('abc', 'def', site: 'https://example.org', authorize_url: '/accounts/oauth/authorize').auth_code.authorize_url(redirect_uri: 'http://localhost:8080/oauth2/callback', scope: 'read write')

    expect(@client.authorize_url).to eq(expected_url)
  end

  it 'should make request when access code defined' do
    expect{ @client.get_token }.to_not raise_error
  end

  it 'should raise an error when no access code provided' do
    Admarkt::Api::Client.code = nil

    expect{
      @client.get_token
    }.to raise_error(Admarkt::Api::Error, 'access code required')
  end

  it 'allows to make a new requests using old access code' do
    new_client = Admarkt::Api::Client.new

    expect{ new_client.get_token }.to_not raise_error
  end

  it 'provides shortcut interface to make new request' do
    Admarkt::Api::Client.code = 'sample'

    expect{ Admarkt::Api::Client.request }.to_not raise_error
  end

  it 'should not make a new request for new token' do
    Admarkt::Api::Client.code = 'sample'
    token = Admarkt::Api::Client.request

    expect(Admarkt::Api::Client.request.object_id).to eq(token.object_id)
  end
end




