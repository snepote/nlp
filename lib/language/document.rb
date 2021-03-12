require 'google/cloud/language'
require 'json'

module Language
  class Document
    def initialize(text_content:)
      @language_service = Google::Cloud::Language.language_service
      @document         = { content: text_content, type: :PLAIN_TEXT }
    end

    private
    def method_missing(m, *args, &block)
      %w[analyze_sentiment analyze_entities analyze_syntax classify_text].include?(m.to_s) ? obtain(m) : super
    end

    def obtain(method)
      attribute = "@#{method}"
      value = instance_variable_get(attribute)
      if value.nil?
        value = @language_service.send(method, document: @document)
        instance_variable_set(attribute, to_hash(object: value))
      end
      instance_variable_get(attribute)
    end

    def to_hash(object:)
      JSON.parse(object.to_json, symbolize_names: true)
    end

    def json_serialize(object:)
      content = JSON.pretty_generate(JSON.parse(object.to_json))
    end
  end
end
