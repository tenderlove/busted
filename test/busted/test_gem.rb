require File.expand_path(File.join(File.dirname(__FILE__), "..", "helper"))

module Busted
  class TestGem < TestCase
    def setup
      require 'rubygems'
      dep = ::Gem::Dependency.new('', ::Gem::Requirement.default)
      specs = ::Gem.source_index.search dep
      @spec = specs.first
      @name = @spec.name
      assert @name
    end

    def test_spec_for
      broken_gem = Busted::Gem.spec_for(@name)
      assert broken_gem
      assert broken_gem.version
    end

    def test_archive_file
      broken = Busted::Gem.new(@spec)
      filename = broken.archive_file
      assert_match Dir::tmpdir, filename
      assert File.exists?(filename)
    end

    def test_ruby_info
      broken = Busted::Gem.new(@spec)
      filename = broken.ruby_info_file
      assert_match Dir::tmpdir, filename
      assert File.exists?(filename)
      assert_match /txt$/, filename
      contents = File.read(filename)
      Config::CONFIG.each { |k,v|
        assert_match k, contents
        assert_match v, contents
      }
    end

    def test_gem_information
      broken = Busted::Gem.new(@spec)
      filename = broken.gem_info_file
      assert_match Dir::tmpdir, filename
      assert File.exists?(filename)
      assert_match /txt$/, filename
      contents = File.read(filename)
      assert_match ::Gem::RubyGemsVersion, contents
      assert_match RUBY_VERSION, contents
      assert_match RUBY_RELEASE_DATE, contents
      assert_match RUBY_PLATFORM, contents
      assert_match ::Gem.dir, contents
      assert_match ::Gem.ruby, contents
      assert_match ::Gem.bindir, contents
      ::Gem.platforms.each { |platform|
        assert_match platform, contents
      }
      ::Gem.path.each { |path|
        assert_match path, contents
      }
      ::Gem.configuration.each do |name,value|
        assert_match name.inspect, contents
        assert_match value.inspect, contents
      end
      ::Gem.sources.each do |s|
        assert_match s, contents
      end
    end
  end
end
