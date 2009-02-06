module Busted
  class Gem
    class << self
      def spec_for name, version = nil
        require 'rubygems'
        dep = ::Gem::Dependency.new(name, version || ::Gem::Requirement.default)
        specs = ::Gem.source_index.search dep
        specs.sort_by { |spec|
          File::Stat.new(spec.full_gem_path).mtime
        }.last
      end
    end

    def initialize gemspec
      @gemspec = gemspec
    end
  end
end
