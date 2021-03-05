def search_tweets terms:
  require 'twitter'
  require 'json'

  twitter = Twitter::REST::Client.new(
    JSON.parse(File.read(File.expand_path("#{__dir__}/../../secrets/twitter.json")))
  )

  hash = {}
  count = 0
  twitter.search(terms).take(10).each do |tweet|
    hash[tweet.id] = {
      id: tweet.id,
      created_at: tweet.created_at,
      text: tweet.text,
      user: {
        id: tweet.user.id,
        name: tweet.user.name,
        followers_count: tweet.user.followers_count
      }
    }
    count += 1
  end
  output = File.expand_path("#{__dir__}../../../data/tweets.json")
  File.write(output, JSON.pretty_generate(hash))
  puts "#{count} tweets found for \"#{terms}\". Saved to #{output}"
end

search_tweets terms: ARGV[0]
