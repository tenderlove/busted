require 'helper'

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
  end
end
