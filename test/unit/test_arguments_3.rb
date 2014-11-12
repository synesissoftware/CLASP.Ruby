
$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Arguments_3 < Test::Unit::TestCase

	def test_include_flag_1

		args	=	Clasp::Arguments.new [ '-f1', 'value1', '--option1=value1', '--flag2' ], nil

		assert args.include_flag? '-f1'
		assert not(args.include_flag? '-f2')
		assert args.include_flag? '--flag2'
		assert not(args.include_flag? '--option1')
	end

	def test_include_flag_2

		aliases	=	[
			Clasp.Flag('--flag1', :alias => '-f1'),
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '--option1=value1', '--flag2' ], aliases

		assert args.include_flag? '-f1'
		assert args.include_flag? '--flag1'
		assert not(args.include_flag? '-f2')
		assert args.include_flag? '--flag2'
		assert not(args.include_flag? '--option1')
	end

end

