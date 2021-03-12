require_relative '../lib/lib'
require 'twitter'
require 'json'

# Rate limit
# @endpoint: /1.1/search/tweets.json
# GET search/tweets
# 180 Requests / window (900s ?) per user
# 450 Requests / window (900s ?) per app
# @link: https://developer.twitter.com/en/docs/twitter-api/v1/rate-limits

RATE_LIMIT_WAIT = 901
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
  query           = '$AMD'
  search_storage  = Twitter::SearchStorage.new(query: query)
  results         = search_storage.results.sort_by!{ |r| r[:id]}.reverse!
  options         = {tweet_mode: 'extended'}
  if results.kind_of?(Array) && !results.empty?
    options = options.merge({max_id: results.last[:id]})
  end

  twitter.search(query, options).take(100).each do |tweet|
    storage.save(object: tweet)
    search_storage.add_and_save(object: tweet)
    puts "#{tweet.id} at #{tweet.created_at} by #{tweet.user.name}"
  end
rescue Twitter::Error => e
  puts e
  puts "sleeping #{RATE_LIMIT_WAIT}"
  sleep RATE_LIMIT_WAIT
  retry
end
