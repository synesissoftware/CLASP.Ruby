
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
		assert_equal 'f1', args.flags[0].given_label
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
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal '--flag2', args.flags[1].to_s
		assert_equal '--flag2', args.flags[1].name
		assert_equal 'flag2', args.flags[1].given_label
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
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal '--flag2', args.flags[1].to_s
		assert_equal '--flag2', args.flags[1].name
		assert_equal 'flag2', args.flags[1].given_label
		assert_equal '--flag2', args.flags[1].given_name
		assert_equal 2, args.flags[1].given_hyphens
		assert_nil args.flags[1].argument_alias
		assert_equal '---x', args.flags[2].to_s
		assert_equal '---x', args.flags[2].name
		assert_equal 'x', args.flags[2].given_label
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
		assert_equal 'o1', args.options[0].given_label
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
		assert_equal 'o1', args.options[0].given_label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias
		assert_equal '--option2=value2', args.options[1].to_s
		assert_equal '--option2', args.options[1].name
		assert_equal 'option2', args.options[1].given_label
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
		assert_equal 'o1', args.options[0].given_label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias
		assert_equal '--option2=value2', args.options[1].to_s
		assert_equal '--option2', args.options[1].name
		assert_equal 'option2', args.options[1].given_label
		assert_equal 'value2', args.options[1].value
		assert_equal '--option2', args.options[1].given_name
		assert_equal 2, args.options[1].given_hyphens
		assert_nil args.options[1].argument_alias
		assert_equal '---the-third-option=the third value', args.options[2].to_s
		assert_equal '---the-third-option', args.options[2].name
		assert_equal 'the-third-option', args.options[2].given_label
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
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias

		assert_equal 1, args.options.size
		assert_equal '--first-option=val1', args.options[0].to_s
		assert_equal '--first-option', args.options[0].name
		assert_equal 'first-option', args.options[0].given_label
		assert_equal 'val1', args.options[0].value
		assert_equal '--first-option', args.options[0].given_name
		assert_equal 2, args.options[0].given_hyphens

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_double_hyphen_1

		args	=	Clasp::Arguments.new [ '-f1', 'value1', '--', '-f2' ]

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias

		assert_equal 0, args.options.size

		assert_equal 2, args.values.size
		assert_equal 'value1', args.values[0]
		assert_equal '-f2', args.values[1]
	end

	def test_double_hyphen_2

		args	=	Clasp::Arguments.new [ '-f1', 'value1', '--', '-f2', '--', '--option1=v1' ]

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias

		assert_equal 0, args.options.size

		assert_equal 4, args.values.size
		assert_equal 'value1', args.values[0]
		assert_equal '-f2', args.values[1]
		assert_equal '--', args.values[2]
		assert_equal '--option1=v1', args.values[3]
	end

	def test_flag_aliases_1

		aliases	=	[
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '-x', '--delete' ], aliases

		assert_equal 3, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal '-x', args.flags[1].to_s
		assert_equal '-x', args.flags[1].name
		assert_equal 'x', args.flags[1].given_label
		assert_equal '-x', args.flags[1].given_name
		assert_equal 1, args.flags[1].given_hyphens
		assert_nil args.flags[1].argument_alias
		assert_equal '--delete', args.flags[2].to_s
		assert_equal '--delete', args.flags[2].name
		assert_equal 'delete', args.flags[2].given_label
		assert_equal '--delete', args.flags[2].given_name
		assert_equal 2, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_flag_aliases_2

		aliases	=	[
			Clasp.Flag('--expand', :alias => '-x')
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '-x', '--delete' ], aliases

		assert_equal 3, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal '--expand', args.flags[1].to_s
		assert_equal '--expand', args.flags[1].name
		assert_equal 'x', args.flags[1].given_label
		assert_equal '-x', args.flags[1].given_name
		assert_equal 1, args.flags[1].given_hyphens
		assert_equal aliases[0], args.flags[1].argument_alias
		assert_equal '--delete', args.flags[2].to_s
		assert_equal '--delete', args.flags[2].name
		assert_equal 'delete', args.flags[2].given_label
		assert_equal '--delete', args.flags[2].given_name
		assert_equal 2, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_flag_aliases_3

		aliases	=	[
			Clasp.Flag('--expand', :aliases => [ '-x', '--x' ])
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '-x', '--delete', '--x' ], aliases

		assert_equal 4, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal '--expand', args.flags[1].to_s
		assert_equal '--expand', args.flags[1].name
		assert_equal 'x', args.flags[1].given_label
		assert_equal '-x', args.flags[1].given_name
		assert_equal 1, args.flags[1].given_hyphens
		assert_equal aliases[0], args.flags[1].argument_alias
		assert_equal '--delete', args.flags[2].to_s
		assert_equal '--delete', args.flags[2].name
		assert_equal 'delete', args.flags[2].given_label
		assert_equal '--delete', args.flags[2].given_name
		assert_equal 2, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias
		assert_equal '--expand', args.flags[3].to_s
		assert_equal '--expand', args.flags[3].name
		assert_equal 'x', args.flags[3].given_label
		assert_equal '--x', args.flags[3].given_name
		assert_equal 2, args.flags[3].given_hyphens
		assert_equal aliases[0], args.flags[3].argument_alias

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_aliases_1

		aliases	=	[
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '-o=value' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens

		assert_equal 1, args.options.size
		assert_equal '-o=value', args.options[0].to_s
		assert_equal '-o', args.options[0].name
		assert_equal 'o', args.options[0].given_label
		assert_equal 'value', args.options[0].value
		assert_equal '-o', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_aliases_2

		aliases	=	[
			Clasp.Option('--option', :aliases => [ '-o' ])
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '-o=value' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens

		assert_equal 1, args.options.size
		assert_equal '--option=value', args.options[0].to_s
		assert_equal '--option', args.options[0].name
		assert_equal 'o', args.options[0].given_label
		assert_equal 'value', args.options[0].value
		assert_equal '-o', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_aliases_3

		aliases	=	[
			Clasp.Option('--option', :aliases => [ '-o' ])
		]
		args	=	Clasp::Arguments.new [ '-f1', 'value1', '-o', 'value' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens

		assert_equal 1, args.options.size
		assert_equal '--option=value', args.options[0].to_s
		assert_equal '--option', args.options[0].name
		assert_equal 'o', args.options[0].given_label
		assert_equal 'value', args.options[0].value
		assert_equal '-o', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

end


