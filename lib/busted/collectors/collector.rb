module Busted
  module Collectors
    class Collector
      def initialize scratch_dir
        @scratch_dir = scratch_dir
        Dir.chdir @scratch_dir
      end

      def process gemspec
      end
    end
  end
end
