require 'tempfile'
require 'fileutils'
require 'rbconfig'
require 'erb'

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
      @tarcommand = 'tar'
      @zipcommand = 'zip'
      @scratch_dir = File.join(Dir.tmpdir, Time.now.to_i.to_s)
      FileUtils.mkdir_p(@scratch_dir)
      Dir.chdir @scratch_dir
    end

    def archive_file
      copy_gem
      archive_prefix = File.basename(@gemspec.full_gem_path)
      Dir.chdir(Dir::tmpdir) do
        begin
          system %{#{@tarcommand} zcf #{archive_prefix}.tar.gz #{archive_prefix}}
          return File.join(Dir::tmpdir, "#{archive_prefix}.tar.gz")
        rescue
          system %{#{@zipcommand} -r #{archive_prefix}.zip #{archive_prefix}}
          return File.join(Dir::tmpdir, "#{archive_prefix}.zip")
        end
      end
    end

    def ruby_info_file
      Collectors::RubyInfo.new(@scratch_dir).process(@gemspec)
    end

    def gem_info_file
      Collectors::GemInfo.new(@scratch_dir).process(@gemspec)
    end

    private
    def copy_gem
      Collectors::GemArchiver.new(@scratch_dir).process(@gemspec)
    end
  end
end
