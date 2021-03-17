require_relative '../lib/lib'
require 'twitter'
require 'json'
require 'ostruct'

query           = '$AMD'
search_storage  = Twitter::SearchStorage.new(query: query)
results         = search_storage.results.sort_by!{ |r| r[:id]}.reverse!
if results.kind_of?(Array) && !results.empty?
  language_storage = Language::Storage.new
  results = Serie::Round.new serie: results
  puts "id;created_at;name;followers_count;score"
  results.round(interval: Serie::FIFTEEN_MIN).each do |tweet|
    tweet = JSON.parse(tweet.to_json.to_s, object_class: OpenStruct)
    sentiment = JSON.parse(language_storage.read(name: tweet.id).to_json.to_s, object_class: OpenStruct)
    unless sentiment.nil?
      score = sentiment.analyze_sentiment.documentSentiment.score || nil
      created_at = Time.parse(tweet.created_at).strftime('%d/%m/%Y %T')
      puts "#{tweet.id};#{created_at};#{tweet.user.name};#{tweet.user.followers_count};#{score}"
    end
  end
end
