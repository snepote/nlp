require 'slugify'
require 'json'

module Twitter
  class SearchStorage
    attr_reader :filename, :results

    def initialize(path: File.join(__dir__, '..', '..', 'data', 'twitter'), query:, options: nil)
      @path     = path
      @query    = query
      @filename = File.join(@path, "#{query.to_s.strip.slugify}.json")
      @results  = []
      load
    end

    def add(object:)
      object = filter(object: object)
      found = @results.find_index { |r| r[:id] == object[:id] }
      if found
        @results[found] = object
      else
        @results << object
      end
    end

    def save
      File.write(@filename, JSON.pretty_generate({ query: @query, results: @results }))
    end

    def add_and_save(object:)
      add(object: object)
      save
    end

private
    def filter(object:)
      hash = JSON.parse(object.to_h.to_json, symbolize_names: true)
      hash.slice(:id, :created_at, :text, :user).merge(
        {user: hash[:user].slice(:id, :name, :followers_count)}
      )
    end

    def load
      if File.exists?(@filename)
        json = JSON.parse(File.read(@filename), symbolize_names: true)
        @results = json[:results]
      else
        FileUtils.mkdir_p(@path) unless Dir.exist?(@path)
        save
      end
    end
  end
end
