require 'spec_helper'

describe 'ad specification' do
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
  end

  describe 'creation' do
    before do
      stub_request(:post, "https://example.org/ad").
        with(:body => "[]",
            :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer 5781def0-bccb-49dd-938d-3b23d664bd0d', 'Content-Type'=>'application/sellside.ad-v1+json', 'User-Agent'=>'Faraday v0.9.1'}).
        to_return(:status => 400, :body => "", :headers => {})

      stub_request(:post, "https://example.org/ad").
         with(:body => "[{\"title\":\"title\"},{\"description\":\"description\"},{\"categoryId\":19},{\"externalId\":\"externalId\"},{\"status\":\"status\"},{\"currency\":\"EUR\"},{\"priceType\":\"priceType\"},{\"price\":1000},{\"salutation\":\"salutation\"},{\"sellerName\":\"sellerName\"},{\"postcode\":\"1234DC\"},{\"shippingOptions\":[{\"type\":\"SHIP\",\"pickupLocation\":\"PICKUP\"}]}]",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer 5781def0-bccb-49dd-938d-3b23d664bd0d', 'Content-Type'=>'application/sellside.ad-v1+json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => "", :headers => {})
    end
    it 'should fail to create new ad resource without mandatory attrs' do
      expect{
        ad = Admarkt::Api::Ad.new
        ad.save
      }.to raise_error(Admarkt::Api::Error)
    end

    it 'should be able to create ad resource when mandatory attrs passed' do
      attrs = {
        :title => 'title',
        :description => 'description',
        :categoryId => 19,
        :externalId => 'externalId',
        :status => 'status',
        :currency => 'EUR',
        :priceType => 'priceType',
        :price => 1000,
        :salutation => 'salutation',
        :sellerName => 'sellerName',
        :postcode => '1234DC',
        :shippingOptions => [
          {
            :type => 'SHIP',
            :pickupLocation => 'PICKUP'
          }
        ]
      }
      ad = Admarkt::Api::Ad.new(attrs)
      expect(ad.save).to be_truthy
    end
  end

  describe 'get single resource' do
    let(:body){ JSON.load(File.read(File.join(File.expand_path('spec/fixtures'), 'ad.json'))) }
    before do
      stub_request(:get, "https://example.org/ad/42").
        with(:headers => {'Accept'=>'application/sellside.ad-v1+json, application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer 5781def0-bccb-49dd-938d-3b23d664bd0d', 'User-Agent'=>'Faraday v0.9.1'}).
        to_return(:status => 200, :body => body)
    end
    it 'returns ad on find' do
      ad = Admarkt::Api::Ad.find(42)
      expect(ad.attributes.keys).to eq(body.keys.map(&:to_sym))
    end
  end
end
