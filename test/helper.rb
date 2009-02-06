require 'test/unit'
require 'busted'

module Busted
  class TestCase < Test::Unit::TestCase
    unless RUBY_VERSION >= '1.9'
      undef :default_test
    end
  end
end
