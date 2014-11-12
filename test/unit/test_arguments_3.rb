
$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Arguments_3 < Test::Unit::TestCase

	def test_include_flag_1

		args	=	Clasp::Arguments.new [ '-f1', 'value1', '--option1=value1', '--flag2' ], nil

		assert args.flags.include? '-f1'
		assert not(args.flags.include? '-f2')
		assert args.flags.include? '--flag2'
		assert not(args.flags.include? '--option1')
	end

	def test_include_flag_2

		aliases	=	[
			Clasp.Flag('--flag1', :alias => '-f1'),
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '--option1=value1', '--flag2' ], aliases

		assert args.flags.include? '-f1'
		assert args.flags.include? '--flag1'
		assert not(args.flags.include? '-f2')
		assert args.flags.include? '--flag2'
		assert not(args.flags.include? '--option1')
	end

	def test_combined_flags_1

		aliases	=	[
			Clasp.Flag('--delete', :alias => '-d'),
			Clasp.Flag('--update', :alias => '-u'),
		]
		args	=	Clasp::Arguments.new [ '-du' ], aliases

		assert args.flags.include? '--delete'
		assert args.flags.include? '--update'
	end

end

