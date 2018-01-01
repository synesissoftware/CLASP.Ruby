#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Option_required < Test::Unit::TestCase

	def test_Option_required_false_implicit

		o = CLASP.Option('--verbose')

		assert_equal '--verbose', o.name
		assert_equal [], o.aliases
		assert_equal [], o.values_range
		assert_equal nil, o.default_value
		assert_equal ({}), o.extras
		assert_false o.required?
	end

	def test_Option_required_false_explicit

		o = CLASP.Option('--verbose', required: false)

		assert_equal '--verbose', o.name
		assert_equal [], o.aliases
		assert_equal [], o.values_range
		assert_equal nil, o.default_value
		assert_equal ({}), o.extras
		assert_false o.required?
	end

	def test_Option_required_true

		o = CLASP.Option('--verbose', required: true)

		assert_equal '--verbose', o.name
		assert_equal [], o.aliases
		assert_equal [], o.values_range
		assert_equal nil, o.default_value
		assert_equal ({}), o.extras
		assert_true o.required?
	end
end


