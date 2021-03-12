require 'slugify'

module Language
  class Storage
    def initialize(path: File.expand_path(File.join(__dir__, '..', '..', 'data', 'language')))
      @path = path
    end

    def save(json:, name:)
      FileUtils.mkdir_p(@path) unless File.exists?(@path)
      File.write(filename(name: name), json)
    end

    def read(name:)
      filename = filename(name: name)
      return JSON.parse(File.read(filename), symbolize_names: true) if File.exists? filename
      nil
    end

    private
    def filename(name:)
      File.join(@path, "#{name.to_s.strip.slugify}.json")
    end
  end
end
