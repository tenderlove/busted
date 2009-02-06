require 'tempfile'
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
      template_file = File.join(BASEDIR, 'templates', 'ruby_info.erb')
      template = ERB.new(File.read(template_file))
      target = File.join(Dir::tmpdir, 'ruby_info.txt')
      File.open(target, 'wb') { |f|
        f.write template.result(binding)
      }
      target
    end

    def gem_info_file
      template_file = File.join(BASEDIR, 'templates', 'gem_info.erb')
      template = ERB.new(File.read(template_file))
      target = File.join(Dir::tmpdir, 'gem_info.txt')
      File.open(target, 'wb') { |f|
        f.write template.result(binding)
      }
      target
    end

    private
    def copy_gem
      dirname = File.join(Dir::tmpdir, File.basename(@gemspec.full_gem_path))
      FileUtils.rm_rf(dirname)
      FileUtils.mkdir_p(dirname)
      FileUtils.cp_r(@gemspec.full_gem_path, dirname)
      dirname
    end
  end
end
