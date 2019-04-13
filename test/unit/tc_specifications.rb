#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Specifications_1 < Test::Unit::TestCase

	def test_simple_Flag

		flag_debug	=	CLASP.Flag('--name')
		flag_logged	=	CLASP.Flag('--logged')

		assert_equal flag_debug, flag_debug
		assert_equal flag_debug, '--name'
		assert_not_equal flag_logged, flag_debug
	end
end


