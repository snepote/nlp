require_relative '../lib/lib'
require 'twitter'
require 'json'

$starting_id   = 1367624267614081028 # @todo: remove me

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

  results         =  search_storage.results.sort_by!{ |r| r[:id]}.reverse!
  options         = {tweet_mode: 'extended'}
  if results.kind_of?(Array) && !results.empty?
    options = options.merge({since_id: results.last[:id]})
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
