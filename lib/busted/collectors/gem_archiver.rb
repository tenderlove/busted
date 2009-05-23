module Busted
  module Collectors
    class GemArchiver < Collector
      def process gemspec
        dirname = File.expand_path('.')
        FileUtils.rm_rf(dirname)
        FileUtils.mkdir_p(dirname)
        FileUtils.cp_r(gemspec.full_gem_path, dirname)
        File.join(dirname, File.basename(gemspec.full_gem_path))
      end
    end
  end
end
