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

syntax_from_text text_content: "The cat plays."
