def search_tweets terms:
  require 'twitter'
  require 'yaml'

  twitter = Twitter::REST::Client.new(
    JSON.parse(File.read(File.expand_path("#{__dir__}/../../secrets/twitter.json")))
  )

  output = File.expand_path("#{__dir__}/data/tweets.yml")

  twitter.search(terms).take(10).each do |tweet|
    puts "[#{tweet.id}] created at #{tweet.created_at} by #{tweet.user.name} who has #{tweet.user.followers_count} followers"
    puts tweet.text
    # File.write(output, YAML.dump(tweet), mode: 'a')
  end
end

search_tweets terms: ARGV[0]
