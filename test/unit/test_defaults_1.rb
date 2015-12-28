#!/usr/bin/ruby
#
# File:     test/unit/test_defaults_1.rb
#

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_defaults < Test::Unit::TestCase

	def test_responds_to_Help

		assert CLASP::Flag.respond_to? :Help
	end

	def test_Help_is_idempotent

		help_1	=	CLASP::Flag.Help
		help_2	=	CLASP::Flag.Help

		assert_same help_1, help_2
	end

	def test_Help_attributes

		assert_equal '--help', CLASP::Flag.Help.name

		assert_equal [], CLASP::Flag.Help.aliases

		assert_equal 'shows this help and terminates', CLASP::Flag.Help.help
	end


	def test_responds_to_Version

		assert CLASP::Flag.respond_to? :Version
	end

	def test_Version_is_idempotent

		version_1	=	CLASP::Flag.Version
		version_2	=	CLASP::Flag.Version

		assert_same version_1, version_2
	end

	def test_Version_attributes

		assert_equal '--version', CLASP::Flag.Version.name

		assert_equal [], CLASP::Flag.Version.aliases

		assert_equal 'shows version and terminates', CLASP::Flag.Version.help
	end
end

