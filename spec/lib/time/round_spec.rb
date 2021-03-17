require 'serie/round'

RSpec.describe Serie::Round do
  let(:round) { described_class.new }
  let(:serie) {
    [
      { created_at: Time.parse('00:05:00'), value: 10.05 },
      { created_at: Time.parse('00:07:01'), name: 'Sebastian' },
      { created_at: Time.parse('02:34:56') },
      { created_at: Time.parse('20:55:12') }
    ]
  }

  describe '#floor' do
    context 'using 15m interval' do
      it 'return all times rounded down to the inmediate quarter' do
        expect(round.floor(serie: serie)).to eq(
          [
            { created_at: Time.parse('00:00:00'), value: 10.05  },
            { created_at: Time.parse('00:00:00'), name: 'Sebastian' },
            { created_at: Time.parse('02:30:00') },
            { created_at: Time.parse('20:45:00') }
          ]
        )
      end
    end

    context 'using 1h interval' do
      it 'return all times rounded down to the hour' do
        expect(round.floor(serie: serie, interval: Serie::ONE_HOUR)).to eq(
          [
            { created_at: Time.parse('00:00:00'), value: 10.05  },
            { created_at: Time.parse('00:00:00'), name: 'Sebastian' },
            { created_at: Time.parse('02:00:00') },
            { created_at: Time.parse('20:00:00') }
          ]
        )
      end
    end
  end

  describe '#round' do
    context 'using 15m interval' do
      it 'return all times rounded to the inmediate quarter' do
        expect(round.round(serie: serie)).to eq(
          [
            { created_at: Time.parse('00:00:00'), value: 10.05  },
            { created_at: Time.parse('00:00:00'), name: 'Sebastian' },
            { created_at: Time.parse('02:30:00') },
            { created_at: Time.parse('21:00:00') }
          ]
        )
      end
    end

    context 'using 1h interval' do
      it 'return all time rounded to the inmediate hour' do
        expect(round.round(serie: serie, interval: Serie::ONE_HOUR)).to eq(
          [
            { created_at: Time.parse('00:00:00'), value: 10.05  },
            { created_at: Time.parse('00:00:00'), name: 'Sebastian' },
            { created_at: Time.parse('03:00:00') },
            { created_at: Time.parse('21:00:00') }
          ]
        )
      end
    end

    context 'when time fields is not of type Time' do
      it 'return the non Time values converted to time' do
        wrong_type_serie = [
          { created_at: 'Thu Mar 11 14:51:07 +0000 2021', value: 1 },
          { created_at: 'Thu Mar 11 14:48:21 +0000 2021', value: 2 }
        ]

        expect(round.round(serie: wrong_type_serie)).to eq(
          [
            { created_at: Time.parse('Thu Mar 11 14:45:00 +0000 2021'), value: 1 },
            { created_at: Time.parse('Thu Mar 11 14:45:00 +0000 2021'), value: 2 }
          ]
        )
      end
    end
  end
end
