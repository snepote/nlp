require 'twitter'
require 'json'
require 'ostruct'

twitter_client = Twitter::REST::Client.new do |config|
  credentials = JSON.parse(
    File.read(File.expand_path("#{__dir__}/../../secrets/twitter.json")),
    object_class: OpenStruct
  )
  config.consumer_key        = credentials.consumer_key
  config.consumer_secret     = credentials.consumer_secret
  config.access_token        = credentials.access_token
  config.access_token_secret = credentials.access_token_secret
end
