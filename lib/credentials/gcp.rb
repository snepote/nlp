require "google/cloud/language"

Google::Cloud::Language.configure do |config|
  config.credentials = File.expand_path "#{__dir__}/../../secrets/gcp.json"
end
