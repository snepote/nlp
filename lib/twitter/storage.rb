require 'yaml'

module Twitter
  class Storage
    def initialize(path: File.join(__dir__, '..', '..', 'data', 'twitter'))
      @path = path
      FileUtils.mkdir_p(path) unless File.exists?(path)
    end

    def save(object:)
      File.write(File.join(@path, "#{object.id}.yaml"), YAML.dump(object))
      object.id
    end

    def load(id:)
      YAML.load(File.read(File.join(@path, "#{id}.yaml")))
    end
  end
end
