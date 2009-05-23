require 'helper'

module Busted
  module Collectors
    class TestRubyInfo < TestCase
      def setup
        @scratch_dir = File.join(Dir.tmpdir, $$.to_s)
        FileUtils.mkdir_p @scratch_dir
        @ri = RubyInfo.new @scratch_dir
      end

      def test_writes_to_scratch_dir
        filename = @ri.process
        assert_match @scratch_dir, filename
      end

      def test_process
        filename = @ri.process
        assert File.exists?(filename)
        assert_match /txt$/, filename
        contents = File.read(filename)
        Config::CONFIG.each { |k,v|
          assert_match k, contents
          assert_match v, contents
        }
      end
    end
  end
end
