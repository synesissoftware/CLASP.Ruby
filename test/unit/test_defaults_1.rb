#!/usr/bin/ruby
#
# File:     test/unit/test_defaults_1.rb
#

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_defaults < Test::Unit::TestCase

	def test_responds_to_Help

		assert Clasp::Flag.respond_to? :Help
	end

	def test_Help_is_idempotent
		help_1	=	Clasp::Flag.Help
		help_2	=	Clasp::Flag.Help

		assert_same help_1, help_2
	end

	def test_Help_attributes

		assert_equal '--help', Clasp::Flag.Help.name

		assert_equal [], Clasp::Flag.Help.aliases

		assert_equal 'shows this help and terminates', Clasp::Flag.Help.help
	end


	def test_responds_to_Version

		assert Clasp::Flag.respond_to? :Version
	end

	def test_Version_is_idempotent
		version_1	=	Clasp::Flag.Version
		version_2	=	Clasp::Flag.Version

		assert_same version_1, version_2
	end

	def test_Version_attributes

		assert_equal '--version', Clasp::Flag.Version.name

		assert_equal [], Clasp::Flag.Version.aliases

		assert_equal 'shows version and terminates', Clasp::Flag.Version.help
	end
end

