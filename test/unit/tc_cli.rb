#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

require 'xqsr3/extensions/test/unit'

require 'stringio'

class Test_CLI < Test::Unit::TestCase

	def test_invalid_aliases_types

		assert_raise_with_message(::TypeError, 'each element in aliases array must be one of the types CLASP::FlagAlias, CLASP::OptionAlias, or CLASP::Alias') { CLASP.show_usage([ 'abc', :def ]) }

		assert_raise_with_message(::TypeError, 'each element in aliases array must be one of the types CLASP::FlagAlias, CLASP::OptionAlias, or CLASP::Alias') { CLASP.show_version([ 'abc', :def ]) }
	end
end

