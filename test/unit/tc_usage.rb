#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

require 'stringio'

class Test_Usage < Test::Unit::TestCase

	def test_empty_default

		aliases	=	[]

		stream	=	StringIO.new

		CLASP.show_usage aliases, stream: stream, program_name: 'myprog'

		assert_equal "USAGE: myprog [ ... flags and options ... ]\n\n", stream.string
	end

	def test_empty_all

		aliases	=	[]

		stream	=	StringIO.new

		CLASP.show_usage aliases, stream: stream, program_name: 'myprog', flags_and_options: ''

		assert_equal "USAGE: myprog\n\n", stream.string
	end

	def test_empty_all_with_info_line_of_one_string

		aliases	=	[]

		stream	=	StringIO.new

		info	=	'myprog version'

		CLASP.show_usage aliases, stream: stream, program_name: 'myprog', flags_and_options: '', info_lines: info

		assert_equal "myprog version\nUSAGE: myprog\n\n", stream.string
	end

	def test_empty_all_with_info_lines

		aliases	=	[]

		stream	=	StringIO.new

		info_lines	=	[

			'Synesis Software My Program',
			'version 1',
		]

		CLASP.show_usage aliases, stream: stream, program_name: 'myprog', flags_and_options: '', info_lines: info_lines

		assert_equal "Synesis Software My Program\nversion 1\nUSAGE: myprog\n\n", stream.string
	end

	def test_empty_all_with_info_lines_including_version

		aliases	=	[]

		stream	=	StringIO.new

		info_lines	=	[

			'Synesis Software My Program',
			:version
		]

		CLASP.show_usage aliases, stream: stream, program_name: 'myprog', flags_and_options: '', info_lines: info_lines, version: [ 1, 0, 1], version_prefix: 'v'

		assert_equal "Synesis Software My Program\nmyprog v1.0.1\nUSAGE: myprog\n\n", stream.string
	end

	def test_one_alias_default

		aliases	=	[

			CLASP::Flag.Version
		]

		stream	=	StringIO.new

		CLASP.show_usage aliases, stream: stream, program_name: 'myprog'

		assert_equal "USAGE: myprog [ ... flags and options ... ]\n\nflags/options:\n\n\t--version\n\t\t#{CLASP::Flag.Version.help}\n\n", stream.string
	end

	def test_one_alias_all

		aliases	=	[

			CLASP::Flag.Version
		]

		stream	=	StringIO.new

		CLASP.show_usage aliases, stream: stream, program_name: 'myprog', flags_and_options: ''

		assert_equal "USAGE: myprog\n\nflags/options:\n\n\t--version\n\t\t#{CLASP::Flag.Version.help}\n\n", stream.string
	end
end

