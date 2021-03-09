require 'iex-ruby-client'
require 'json'
#
# file = File.expand_path(File.join(__dir__, '..', 'secrets', 'iexcloud.json'))
# credentials = JSON.parse(File.read(file), object_class: OpenStruct)
# iexcloud = IEX::Api::Client.new(
#   publishable_token: credentials.publishable_token, # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
#   secret_token: credentials.secret_token, # defaults to ENV['IEX_API_SECRET_TOKEN']
#   endpoint: 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
# )
# symbol = 'AMD'
# options = {range: '21d'}
# historical_prices = iexcloud.historical_prices(symbol, options)
# pp historical_prices

output = File.expand_path(File.join(__dir__, '..', 'data', 'iexcloud.json'))
File.write(output, JSON.pretty_generate(historical_prices))
puts "#{historical_prices.size} tweets found for \"#{query}\". Saved to #{output}"
