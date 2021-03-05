require 'yaml'
require 'twitter'

source = File.expand_path("#{__dir__}/../../data/tweets.yml")
tweets = YAML.load(File.read(source))

pp tweets
