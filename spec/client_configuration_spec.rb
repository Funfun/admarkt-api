require 'spec_helper'

describe 'client config spec' do
  it 'should honor setting options' do
    Admarkt::Api::Client.setup(
      :client_id => 'abc',
      :client_secret => 'def',
      :redirect_uri => 'http://localhost:8080/oauth2/callback',
      :username => 'john',
      :password => 'topsecret',
      :site => 'https://example.org'
    )

    expect(Admarkt::Api::Client.config).to eq({
      :client_id => 'abc',
      :client_secret => 'def',
      :redirect_uri => 'http://localhost:8080/oauth2/callback',
      :username => 'john',
      :password => 'topsecret',
      :site => 'https://example.org'})
  end
end
