module Twitter
  class Sentiment
    def initialize(language_service)
      @language_service = language_service
    end
    def score(text:)
      @language_service.score(text: text)
    end
  end
end
