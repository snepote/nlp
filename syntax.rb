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

def syntax_from_text text_content:
  # [START language_syntax_text]
  # text_content = "Text to analyze syntax of"

  require "google/cloud/language"

  language = Google::Cloud::Language.language_service

  document = { content: text_content, type: :PLAIN_TEXT }
  response = language.analyze_syntax document: document

  sentences = response.sentences
  tokens    = response.tokens

  puts "Sentences: #{sentences.count}"
  puts "Tokens: #{tokens.count}"

  tokens.each do |token|
    puts "#{token.part_of_speech.tag} #{token.text.content}"
  end
  # [END language_syntax_text]
end

syntax_from_text text_content: ARGV[0]
