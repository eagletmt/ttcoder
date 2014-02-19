require 'find'

module FindFiles
  def find_files(root, ext)
    Enumerator.new do |y|
      Find.find(root.to_s) do |path|
        if path == Bundler.bundle_path.to_s
          Find.prune
        end
        if File.extname(path) == ext
          y << path
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include(FindFiles)
end
