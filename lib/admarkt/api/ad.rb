module Admarkt
  class Api::Ad
    ATTRS = [:id, :title, :description, :categoryId, :externalId, :status, :currency, :priceType, :price, :cpc, :totalBudget, :dailyBudget, :spentBudget, :salutation, :sellerName, :postcode, :pageNumber, :suggestedCpcForPageOne, :phoneNumber, :allowContactByEmail, :dateCreated, :dateLastUpdated, :links, :images, :attributes, :shippingOptions, :paypalEmail]
    ATTRS.each do |attr|
      attr_accessor :"#{attr}"
    end
    def initialize(attrs = {})
      attrs.each do |attr, val|
        self.send(:"#{attr}=", val)
      end unless attrs.empty?
    end

    def save
      body = ATTRS.map do |k|
        v = self.send(:"#{k}")
        { k => v } unless v.nil?
      end.compact.to_json

      Admarkt::Api::Client.request.post('/ad', body: body, headers: {'Content-Type' => 'application/sellside.ad-v1+json'})
    rescue OAuth2::Error
      fail(Admarkt::Api::Error)
    end

    def self.find(id)
      r = Admarkt::Api::Client.request.get("/ad/#{id}", headers: {'Accept' => 'application/sellside.ad-v1+json, application/json'})
      binding.pry
      new(r.parsed)
    rescue OAuth2::Error
      fail(Admarkt::Api::Error)
    end
  end
end