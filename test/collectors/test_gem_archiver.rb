require 'helper'
require 'find'

module Busted
  module Collectors
    class TestGemArchiver < TestCase
      def setup
        @scratch_dir = File.join(Dir.tmpdir, Time.now.to_i.to_s)
        FileUtils.mkdir_p @scratch_dir
        @ga = GemArchiver.new @scratch_dir

        dep = ::Gem::Dependency.new('', ::Gem::Requirement.default)
        specs = ::Gem.source_index.search dep
        @spec = specs.first
      end

      def test_save_to_scratch_dir
        dir = @ga.process @spec
        assert_match @scratch_dir, dir
      end

      def test_process
        dir = @ga.process @spec
        bn = File.basename(@spec.full_gem_path)
        expected = []
        actual = []

        Find.find(dir) do |path|
          actual << path.sub(/^.*#{bn}/, '')
        end
        Find.find(@spec.full_gem_path) do |path|
          expected << path.sub(/^.*#{bn}/, '')
        end

        assert_equal expected.length, actual.length
        assert_equal expected.sort, actual.sort
      end
    end
  end
end
