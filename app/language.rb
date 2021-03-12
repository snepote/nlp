require_relative '../lib/lib'
require 'json'

def analyze(name:, text_content: text)
  storage  = Language::Storage.new
  document = Language::Document.new(text_content: text_content)
  hash = storage.read(name: name) || { name: name, text: text_content }
  %w[analyze_sentiment].each do |method| # analyze_entities analyze_syntax classify_text
    unless hash.has_key?(method.to_sym)
      puts "[gcp] #{method} for #{name}"
      response = document.send(method)
      hash[method.to_sym] = response
    else
      puts "[gcp] #{method} for #{name} skipped: already defined"
    end
  end
  storage.save(json: JSON.pretty_generate(hash), name: name)
end

search_storage  = Twitter::SearchStorage.new(query: '$AMD')
search_storage.results.each_with_index do |tweet, index|
  tweet = JSON.parse(tweet.to_json.to_s, object_class: OpenStruct)
  analyze(name: tweet.id, text_content: tweet.text)
end
