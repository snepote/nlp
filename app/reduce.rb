require_relative '../lib/lib'
require 'twitter'
require 'rounding'

array = []
array << { day: 'mon', value: 5 }
array << { day: 'mon', value: 10 }
array << { day: 'mon', value: 15 }
array << { day: 'tue', value: 1 }
array << { day: 'tue', value: 2 }
array << { day: 'tue', value: 3 }


avg = array.group_by{ |item| item[:day] }.map do |_, grouped|
  grouped.inject(0) do |sum, hash|
    sum + hash[:value]
  end.fdiv(grouped.size)
end

pp avg

# sum = array.group_by{ |item| item[:day] }.map do |_, grouped|
#   grouped.reduce do |result, item|
#     result[:value] += item[:value]
#     result
#   end
# end

# pp sum

query           = '$AMD'
search_storage  = Twitter::SearchStorage.new(query: query)
results         = search_storage.results.sort_by!{ |r| r[:id]}.reverse!


rounded = Serie::Round.new(serie: results).round(interval: Serie::FIFTEEN_MIN)
# sum     = rounded.group_by{ |item| item[:created_at] }.map do |_, grouped|
#   grouped.reduce do |result, item|
#     result[:avg] = 0 unless result.key?(:avg)
#     result[:user][:followers_count] += item[:user][:followers_count]
#     result.slice(:created_at, :avg, :user).merge(
#       {user: result[:user].slice(:followers_count)}
#     )
#   end
# end
#
# puts sum

# avg = rounded.group_by{ |item| item[:created_at] }.map do |_, grouped|
#   grouped.reduce do |result, item|
#     result[:user][:followers_count] += item[:user][:followers_count]
#     # result.slice(:created_at, :avg, :user).merge(
#     #   {user: result[:user].slice(:followers_count)}
#     # )
#   end #/ grouped.size
# end
#
# puts avg

# if results.kind_of?(Array) && !results.empty?
#   grouped = results.group_by { |tweet| Time.parse(tweet[:created_at]).round_to(Serie::FIFTEEN_MIN) }
#               # .map{ |tweet| tweet[:user][:followers_count] }
#               # .reduce{:+}
#   puts grouped.to_a.first
#   # .inject(0) {|sum, tweet| sum + tweet[:user][:followers_count] }
#   # .inject(0) {|sum, tweet| sum + tweet[:user][:followers_count] }
#
#
#   # puts results
#   #   .select{ |tweet| Time.parse(tweet[:created_at]).round_to(Serie::FIFTEEN_MIN) }
#   #   .map{ |tweet| tweet[:user][:followers_count].to_i }
#   #   .reduce(0) { |sum,val| sum + val }
# end
