require_relative '../lib/lib'
require 'twitter'
require 'time'
require 'faker'
require 'json'
require 'ostruct'

class LanguageService
  def score(text:)
    rand(-1.0..2.0)
  end
end

$starting_id   = 1367624267614081028 # @todo: remove me
def dummy_tweet
  id = $starting_id + rand(0..9)
  $starting_id = id
  hash = {
    id: id,
    created_at: Time.now.utc.to_s,
    text: Faker::Lorem.sentence,
    user: {
      name: Faker::Name.name,
      followers_count: rand(0..99999)
    }
  }
  OpenStruct.new(hash)
end

RATE_LIMIT_WAIT = 2 #901
sentiment       = Twitter::Sentiment.new(LanguageService.new)
storage         = Twitter::Storage.new

twitter         = Twitter::REST::Client.new(
  JSON.parse(
    File.read(
      File.expand_path(File.join(__dir__, '..', 'secrets', 'twitter.json'))
    )
  )
)

i = 0
begin
  10.times do
    tweet = dummy_tweet
    storage.save(object: tweet)
    search_storage.add_and_save(object: tweet)
    raise Twitter::Error.new(rate_limit: 900) if i == 5
    i += 1
  end
rescue Twitter::Error => e
  puts e
  puts "sleeping #{RATE_LIMIT_WAIT}"
  sleep RATE_LIMIT_WAIT
  i += 1
  retry
end


# text = "It's something"
# puts text
# puts sentiment.score text: text
#
# file = File.expand_path(File.join(__dir__, '..', 'data', 'tweets.json'))
# tweets = JSON.parse(File.read(file), object_class: OpenStruct)
#
# tweets.each do |tweet|
#   created_at = Time.parse(tweet.created_at)
#   puts "#{tweet.id} at #{created_at} by #{tweet.user.name} with #{sentiment.score text: tweet.text}"
# end
