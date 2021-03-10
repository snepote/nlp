require 'twitter/sentiment'

class LanguageService
  def score text:
  end
end

RSpec.describe Twitter::Sentiment do
  let(:language_service) {double LanguageService}

  describe '#score' do
    context 'given a "neutral text"' do
      it 'should return 0' do
        text = "neutral text"
        allow(language_service).to receive(:score).with(text: text) { 0 }
        expect(Twitter::Sentiment.new(language_service).score(text: text)).to eq(0)
      end
    end

    context 'given a "negative phrase"' do
      it 'should return a negative score >= -1' do
        text = "negative phrase"
        allow(language_service).to receive(:score).with(text: text) { -0.5 }
        score = Twitter::Sentiment.new(language_service).score(text: text)
        expect(score).to be >= -1
        expect(score).to be < 0
      end
    end

    context 'given a "nice phrase"' do
      it 'should return a positive number less or equal than 1' do
        text = "nice phrase"
        allow(language_service).to receive(:score).with(text: text) { 0.5 }
        score = Twitter::Sentiment.new(language_service).score(text: text)
        expect(score).to be > 0
        expect(score).to be <= 1
      end
    end
  end
end
