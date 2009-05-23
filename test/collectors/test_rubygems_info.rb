require 'helper'

module Busted
  module Collectors
    class TestRubygemsInfo < TestCase
      def setup
        @scratch_dir = File.join(Dir.tmpdir, $$.to_s)
        FileUtils.mkdir_p @scratch_dir
        @gi = RubygemsInfo.new @scratch_dir
      end

      def test_writes_to_scratch_dir
        filename = @gi.process
        assert_match @scratch_dir, filename
      end

      def test_gem_information
        filename = @gi.process
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
end
