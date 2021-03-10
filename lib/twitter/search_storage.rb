require 'slugify'
require 'json'

module Twitter
  class SearchStorage
    attr_reader :filename, :results

    def initialize(path:, query:, options: nil)
      @path     = path
      @query    = query
      @filename = File.join(@path, "#{query.to_s.strip.slugify}.json")
      @results  = []
      load
    end

    def add(object:)
      found = @results.find_index { |r| r[:id] == object[:id] }
      if found
        @results[found] = filter(object: object)
      else
        @results << filter(object: object)
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
      object.slice(:id, :created_at, :text, :user).merge(
        {user: object[:user].slice(:id, :name, :followers_count)}
      )
    end

    def load
      if File.exists?(@filename)
        JSON.parse(File.read(@filename))
      else
        FileUtils.mkdir_p(@path) unless Dir.exist?(@path)
        save
      end
    end
  end
end
