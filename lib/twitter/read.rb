require 'twitter'
require 'json'

def read_tweets_from_json file:
  tweets = JSON.parse(File.read(file), object_class: OpenStruct)
  # pp tweets
  tweets.each do |tweet|
    pp 'hi'
    pp "id: #{tweet.id}"
  end
end

read_tweets_from_json file: File.expand_path("#{__dir__}/../../data/tweets.json")
