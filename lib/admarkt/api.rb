require 'oauth2'
require 'virtus'
require "admarkt/api/version"
require 'admarkt/api/client'
require 'admarkt/api/ad'

module Admarkt
  module Api
    class Error < StandardError; end
  end
end
