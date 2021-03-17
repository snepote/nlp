require 'time'
require 'rounding'

module Serie
  FIFTEEN_MIN = 15 * 60
  ONE_HOUR = 60 * 60

  class Round
    def floor(serie:, field: :created_at, interval: Serie::FIFTEEN_MIN)
      serie.map do |time|
        time[field] = Time.parse(time[field]) unless time[field].is_a?(Time)
        time.merge({ "#{field}": time[field].floor_to(interval)})
      end
    end

    def round(serie:, field: :created_at, interval: Serie::FIFTEEN_MIN)
      serie.map do |time|
        time[field] = Time.parse(time[field]) unless time[field].is_a?(Time)
        time.merge({ "#{field}": time[field].round_to(interval)})
      end
    end
  end
end
