module Busted
  module Collectors
    class GemInfo < Collector
      def process gemspec = nil
        template_file = File.join(BASEDIR, 'templates', 'gem_info.erb')
        template = ERB.new(File.read(template_file))
        target = File.expand_path 'gem_info.txt'
        File.open(target, 'wb') { |f|
          f.write template.result(binding)
        }
        target
      end
    end
  end
end
