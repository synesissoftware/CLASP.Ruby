#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_extras_1 < Test::Unit::TestCase

	def test_Option_with_no_extras

		o = CLASP.Option('--verbose')

		assert_equal '--verbose', o.name
		assert_equal [], o.aliases
		assert_equal [], o.values_range
		assert_equal nil, o.default_value
		assert_equal ({}), o.extras
	end

	def test_Option_with_extras_as_symbol

		o = CLASP.Option('--verbose', extras: :extras)

		assert_equal '--verbose', o.name
		assert_equal [], o.aliases
		assert_equal [], o.values_range
		assert_equal nil, o.default_value
		assert_equal :extras, o.extras
	end

	def test_Option_with_extras_as_hash

		o = CLASP.Option('--verbose', extras: { :abc => 'abc', :def => 'def' })

		assert_equal '--verbose', o.name
		assert_equal [], o.aliases
		assert_equal [], o.values_range
		assert_equal nil, o.default_value
		assert_equal ({ :abc => 'abc', :def => 'def' }), o.extras
	end
end



