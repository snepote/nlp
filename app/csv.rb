require_relative '../lib/lib'
require 'twitter'
require 'json'

query           = '$AMD'
search_storage  = Twitter::SearchStorage.new(query: query)
results         = search_storage.results.sort_by!{ |r| r[:id]}.reverse!
if results.kind_of?(Array) && !results.empty?
  puts "id;created_at;name;followers_count;score"
  results.each do |tweet|
    tweet = JSON.parse(tweet.to_json.to_s, object_class: OpenStruct)
    created_at = Time.parse(tweet.created_at).strftime('%d/%m/%Y %T')
    # @todo: remove fake sentiment score
    puts "#{tweet.id};#{created_at};#{tweet.user.name};#{tweet.user.followers_count};#{rand(-1.0..1.0)}"
  end
end
