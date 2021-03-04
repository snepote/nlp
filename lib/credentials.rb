require "google/cloud/language"

Google::Cloud::Language.configure do |config|
  config.credentials = File.expand_path(
    "#{__dir__}/../secrets/snepote-nlp-sentiment-analysis-972d515b9049.json"
  )
end
