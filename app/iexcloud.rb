require 'iex-ruby-client'
require 'json'
require 'time'

file = File.expand_path(File.join(__dir__, '..', 'secrets', 'iexcloud.json'))
credentials = JSON.parse(File.read(file), object_class: OpenStruct).sandbox
iexcloud = IEX::Api::Client.new(
  publishable_token: credentials.publishable_token, # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
  secret_token: credentials.secret_token, # defaults to ENV['IEX_API_SECRET_TOKEN']
  endpoint: credentials.endpoint
)

symbol = 'AMD'
date = Time.parse("2021-03-25").strftime("%Y%m%d")
options = {range: '5dm', date: date} # One day of data
puts "symbol: #{symbol} for #{options} (time in UTC)"
historical_prices = iexcloud.historical_prices(symbol, options)
puts "time;open;high;low;close"
historical_prices.each do |price|
  time = Time.parse("#{price.date} #{price.label} UTC").strftime('%d/%m/%Y %T')
  puts "#{time};#{price.open};#{price.high};#{price.low};#{price.close}"
end
