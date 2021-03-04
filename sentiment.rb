# Copyright 2016 Google, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'lib/lib'

def sentiment_from_text text_content:
  # [START language_sentiment_text]
  # text_content = "Text to run sentiment analysis on"

  require "google/cloud/language"

  language = Google::Cloud::Language.language_service

  document = { content: text_content, type: :PLAIN_TEXT }
  response = language.analyze_sentiment document: document

  sentiment = response.document_sentiment

  puts "Overall document sentiment: (#{sentiment.score})"
  puts "Sentence level sentiment:"

  sentences = response.sentences

  sentences.each do |sentence|
    sentiment = sentence.sentiment
    puts "#{sentence.text.content}: (#{sentiment.score})"
  end
  # [END language_sentiment_text]
end

sentiment_from_text text_content: ARGV[0]
