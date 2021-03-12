require_relative '../lib/lib'
require 'json'
require 'fileutils'
require 'slugify'
require 'ostruct'

PATH = File.expand_path(File.join(__dir__, '..', 'data', 'language'))
def filename(path: PATH, name:)
  File.join(path, "#{name.to_s.strip.slugify}.json")
end

def save(path: PATH, json:, name:)
  FileUtils.mkdir_p(path) unless File.exists?(path)
  File.write(filename(path: path, name: name), json)
end

def read(path: PATH, name:)
  filename = filename(path: path, name: name)
  return JSON.parse(File.read(filename), symbolize_names: true) if File.exists? filename
  nil
end

def analyze(name:, text_content: text)
  document = Language::Document.new(text_content: text_content)
  hash = read(name: name) || { name: name, text: text_content }
  %w[analyze_sentiment].each do |method| # analyze_entities analyze_syntax classify_text
    unless hash.has_key?(method.to_sym)
      puts "[gcp] #{method} for #{name}"
      response = document.send(method)
      hash[method.to_sym] = response
    else
      puts "[gcp] #{method} for #{name} skipped: already defined"
    end
  end
  save(json: JSON.pretty_generate(hash), name: name)
end

search_storage  = Twitter::SearchStorage.new(query: '$AMD')
search_storage.results.each_with_index do |tweet, index|
  tweet = JSON.parse(tweet.to_json.to_s, object_class: OpenStruct)
  analyze(name: tweet.id, text_content: tweet.text)
  exit if index == 10
end
