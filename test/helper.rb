require 'test/unit'
require 'tempfile'
require 'busted'
require 'rubygems'

module Busted
  class TestCase < Test::Unit::TestCase
    unless RUBY_VERSION >= '1.9'
      undef :default_test
    end
  end
end
