
require 'clasp'

require 'test/unit'

class Test_Arguments < Test::Unit::TestCase

	def test_empty_args

		args	=	Clasp::Arguments.new([])

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_one_value

		args	=	Clasp::Arguments.new([ 'value1' ])

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_two_values

		args	=	Clasp::Arguments.new([ 'value1', 'val2' ])

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal 2, args.values.size
		assert_equal 'value1', args.values[0]
		assert_equal 'val2', args.values[1]
	end

	def test_ten_values

		argv	=	(0 .. 10).map { |n| "value#{n}" }

		args	=	Clasp::Arguments.new(argv)

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal argv.size, args.values.size
		(0 ... argv.size).each do |n|
			assert_equal argv[n], args.values[n]
		end
	end

	def test_one_flag

		args	=	Clasp::Arguments.new([ '-f1' ])

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_two_flags

		args	=	Clasp::Arguments.new([ '-f1', '--flag2' ])

		assert_equal 2, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal '--flag2', args.flags[1].to_s
		assert_equal '--flag2', args.flags[1].name
		assert_equal 'flag2', args.flags[1].label
		assert_equal '--flag2', args.flags[1].given_name
		assert_equal 2, args.flags[1].given_hyphens
		assert_nil args.flags[1].argument_alias

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_three_flags

		args	=	Clasp::Arguments.new([ '-f1', '--flag2', '---x' ])

		assert_equal 3, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal '--flag2', args.flags[1].to_s
		assert_equal '--flag2', args.flags[1].name
		assert_equal 'flag2', args.flags[1].label
		assert_equal '--flag2', args.flags[1].given_name
		assert_equal 2, args.flags[1].given_hyphens
		assert_nil args.flags[1].argument_alias
		assert_equal '---x', args.flags[2].to_s
		assert_equal '---x', args.flags[2].name
		assert_equal 'x', args.flags[2].label
		assert_equal '---x', args.flags[2].given_name
		assert_equal 3, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_one_option

		args	=	Clasp::Arguments.new([ '-o1=v1' ])

		assert_equal 0, args.flags.size

		assert_equal 1, args.options.size
		assert_equal '-o1=v1', args.options[0].to_s
		assert_equal '-o1', args.options[0].name
		assert_equal 'o1', args.options[0].label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias

		assert_equal 0, args.values.size
	end

	def test_two_options

		args	=	Clasp::Arguments.new([ '-o1=v1', '--option2=value2' ])

		assert_equal 0, args.flags.size

		assert_equal 2, args.options.size
		assert_equal '-o1=v1', args.options[0].to_s
		assert_equal '-o1', args.options[0].name
		assert_equal 'o1', args.options[0].label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias
		assert_equal '--option2=value2', args.options[1].to_s
		assert_equal '--option2', args.options[1].name
		assert_equal 'option2', args.options[1].label
		assert_equal 'value2', args.options[1].value
		assert_equal '--option2', args.options[1].given_name
		assert_equal 2, args.options[1].given_hyphens
		assert_nil args.options[1].argument_alias

		assert_equal 0, args.values.size
	end

	def test_three_options

		args	=	Clasp::Arguments.new([ '-o1=v1', '--option2=value2', '---the-third-option=the third value' ])

		assert_equal 0, args.flags.size

		assert_equal 3, args.options.size
		assert_equal '-o1=v1', args.options[0].to_s
		assert_equal '-o1', args.options[0].name
		assert_equal 'o1', args.options[0].label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias
		assert_equal '--option2=value2', args.options[1].to_s
		assert_equal '--option2', args.options[1].name
		assert_equal 'option2', args.options[1].label
		assert_equal 'value2', args.options[1].value
		assert_equal '--option2', args.options[1].given_name
		assert_equal 2, args.options[1].given_hyphens
		assert_nil args.options[1].argument_alias
		assert_equal '---the-third-option=the third value', args.options[2].to_s
		assert_equal '---the-third-option', args.options[2].name
		assert_equal 'the-third-option', args.options[2].label
		assert_equal 'the third value', args.options[2].value
		assert_equal '---the-third-option', args.options[2].given_name
		assert_equal 3, args.options[2].given_hyphens
		assert_nil args.options[2].argument_alias

		assert_equal 0, args.values.size
	end

	def test_one_flag_and_one_option_and_one_value

		args	=	Clasp::Arguments.new [ '-f1', 'value1', '--first-option=val1' ]

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias

		assert_equal 1, args.options.size
		assert_equal '--first-option=val1', args.options[0].to_s
		assert_equal '--first-option', args.options[0].name
		assert_equal 'first-option', args.options[0].label
		assert_equal 'val1', args.options[0].value
		assert_equal '--first-option', args.options[0].given_name
		assert_equal 2, args.options[0].given_hyphens

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

end


