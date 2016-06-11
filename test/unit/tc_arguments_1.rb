#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Arguments < Test::Unit::TestCase

	def test_empty_args

		args	=	CLASP::Arguments.new([])

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_one_value

		args	=	CLASP::Arguments.new([ 'value1' ])

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_two_values

		args	=	CLASP::Arguments.new([ 'value1', 'val2' ])

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal 2, args.values.size
		assert_equal 'value1', args.values[0]
		assert_equal 'val2', args.values[1]
	end

	def test_ten_values

		argv	=	(0 .. 10).map { |n| "value#{n}" }

		args	=	CLASP::Arguments.new(argv)

		assert_equal 0, args.flags.size

		assert_equal 0, args.options.size

		assert_equal argv.size, args.values.size
		(0 ... argv.size).each do |n|
			assert_equal argv[n], args.values[n]
		end
	end

	def test_one_flag

		args	=	CLASP::Arguments.new([ '-f1' ])

		assert_equal 1, args.flags.size
		assert_equal 0, args.flags[0].given_index
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_two_flags

		args	=	CLASP::Arguments.new([ '-f1', '--flag2' ])

		assert_equal 2, args.flags.size
		assert_equal 0, args.flags[0].given_index
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras
		assert_equal 1, args.flags[1].given_index
		assert_equal '--flag2', args.flags[1].to_s
		assert_equal '--flag2', args.flags[1].name
		assert_equal 'flag2', args.flags[1].given_label
		assert_equal '--flag2', args.flags[1].given_name
		assert_equal 2, args.flags[1].given_hyphens
		assert_nil args.flags[1].argument_alias
		assert_equal Hash.new, args.flags[1].extras

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_three_flags

		args	=	CLASP::Arguments.new([ '-f1', '--flag2', '---x' ])

		assert_equal 3, args.flags.size
		assert_equal 0, args.flags[0].given_index
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras
		assert_equal 1, args.flags[1].given_index
		assert_equal '--flag2', args.flags[1].to_s
		assert_equal '--flag2', args.flags[1].name
		assert_equal 'flag2', args.flags[1].given_label
		assert_equal '--flag2', args.flags[1].given_name
		assert_equal 2, args.flags[1].given_hyphens
		assert_nil args.flags[1].argument_alias
		assert_equal Hash.new, args.flags[1].extras
		assert_equal 2, args.flags[2].given_index
		assert_equal '---x', args.flags[2].to_s
		assert_equal '---x', args.flags[2].name
		assert_equal 'x', args.flags[2].given_label
		assert_equal '---x', args.flags[2].given_name
		assert_equal 3, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias
		assert_equal Hash.new, args.flags[2].extras

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_one_option

		args	=	CLASP::Arguments.new([ '-o1=v1' ])

		assert_equal 0, args.flags.size

		assert_equal 1, args.options.size
		assert_equal 0, args.options[0].given_index
		assert_equal '-o1=v1', args.options[0].to_s
		assert_equal '-o1', args.options[0].name
		assert_equal 'o1', args.options[0].given_label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias
		assert_equal Hash.new, args.options[0].extras

		assert_equal 0, args.values.size
	end

	def test_two_options

		args	=	CLASP::Arguments.new([ '-o1=v1', '--option2=value2' ])

		assert_equal 0, args.flags.size

		assert_equal 2, args.options.size
		assert_equal '-o1=v1', args.options[0].to_s
		assert_equal '-o1', args.options[0].name
		assert_equal 'o1', args.options[0].given_label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias
		assert_equal Hash.new, args.options[0].extras
		assert_equal '--option2=value2', args.options[1].to_s
		assert_equal '--option2', args.options[1].name
		assert_equal 'option2', args.options[1].given_label
		assert_equal 'value2', args.options[1].value
		assert_equal '--option2', args.options[1].given_name
		assert_equal 2, args.options[1].given_hyphens
		assert_nil args.options[1].argument_alias
		assert_equal Hash.new, args.options[1].extras

		assert_equal 0, args.values.size
	end

	def test_three_options

		args	=	CLASP::Arguments.new([ '-o1=v1', '--option2=value2', '---the-third-option=the third value' ])

		assert_equal 0, args.flags.size

		assert_equal 3, args.options.size
		assert_equal '-o1=v1', args.options[0].to_s
		assert_equal '-o1', args.options[0].name
		assert_equal 'o1', args.options[0].given_label
		assert_equal 'v1', args.options[0].value
		assert_equal '-o1', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_nil args.options[0].argument_alias
		assert_equal Hash.new, args.options[0].extras
		assert_equal '--option2=value2', args.options[1].to_s
		assert_equal '--option2', args.options[1].name
		assert_equal 'option2', args.options[1].given_label
		assert_equal 'value2', args.options[1].value
		assert_equal '--option2', args.options[1].given_name
		assert_equal 2, args.options[1].given_hyphens
		assert_nil args.options[1].argument_alias
		assert_equal Hash.new, args.options[1].extras
		assert_equal '---the-third-option=the third value', args.options[2].to_s
		assert_equal '---the-third-option', args.options[2].name
		assert_equal 'the-third-option', args.options[2].given_label
		assert_equal 'the third value', args.options[2].value
		assert_equal '---the-third-option', args.options[2].given_name
		assert_equal 3, args.options[2].given_hyphens
		assert_nil args.options[2].argument_alias
		assert_equal Hash.new, args.options[2].extras

		assert_equal 0, args.values.size
	end

	def test_one_flag_and_one_option_and_one_value

		args	=	CLASP::Arguments.new [ '-f1', 'value1', '--first-option=val1' ]

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 1, args.options.size
		assert_equal '--first-option=val1', args.options[0].to_s
		assert_equal '--first-option', args.options[0].name
		assert_equal 'first-option', args.options[0].given_label
		assert_equal 'val1', args.options[0].value
		assert_equal '--first-option', args.options[0].given_name
		assert_equal 2, args.options[0].given_hyphens
		assert_equal Hash.new, args.options[0].extras

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_double_hyphen_1

		args	=	CLASP::Arguments.new [ '-f1', 'value1', '--', '-f2' ]

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 0, args.options.size

		assert_equal 2, args.values.size
		assert_equal 'value1', args.values[0]
		assert_equal '-f2', args.values[1]
	end

	def test_double_hyphen_2

		args	=	CLASP::Arguments.new [ '-f1', 'value1', '--', '-f2', '--', '--option1=v1' ]

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 0, args.options.size

		assert_equal 4, args.values.size
		assert_equal 'value1', args.values[0]
		assert_equal '-f2', args.values[1]
		assert_equal '--', args.values[2]
		assert_equal '--option1=v1', args.values[3]
	end

	def test_double_hyphen_3

		aliases	=	[
			CLASP.Option('--password', alias: '-p', extras: 'extra'),
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-p', '--', 'value2' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 1, args.options.size
		assert_equal '--password=', args.options[0].to_s
		assert_equal '--password', args.options[0].name
		assert_equal 'p', args.options[0].given_label
		assert_nil args.options[0].value
		assert_equal '-p', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_equal 'extra', args.options[0].extras

		assert_equal 2, args.values.size
		assert_equal 'value1', args.values[0]
		assert_equal 'value2', args.values[1]
	end

	def test_flag_aliases_1

		aliases	=	[
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-x', '--delete' ], aliases

		assert_equal 3, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras
		assert_equal '-x', args.flags[1].to_s
		assert_equal '-x', args.flags[1].name
		assert_equal 'x', args.flags[1].given_label
		assert_equal '-x', args.flags[1].given_name
		assert_equal 1, args.flags[1].given_hyphens
		assert_nil args.flags[1].argument_alias
		assert_equal Hash.new, args.flags[1].extras
		assert_equal '--delete', args.flags[2].to_s
		assert_equal '--delete', args.flags[2].name
		assert_equal 'delete', args.flags[2].given_label
		assert_equal '--delete', args.flags[2].given_name
		assert_equal 2, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias
		assert_equal Hash.new, args.flags[2].extras

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_flag_aliases_2

		aliases	=	[
			CLASP.Flag('--expand', alias: '-x')
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-x', '--delete' ], aliases

		assert_equal 3, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras
		assert_equal '--expand', args.flags[1].to_s
		assert_equal '--expand', args.flags[1].name
		assert_equal 'x', args.flags[1].given_label
		assert_equal '-x', args.flags[1].given_name
		assert_equal 1, args.flags[1].given_hyphens
		assert_equal aliases[0], args.flags[1].argument_alias
		assert_equal Hash.new, args.flags[1].extras
		assert_equal '--delete', args.flags[2].to_s
		assert_equal '--delete', args.flags[2].name
		assert_equal 'delete', args.flags[2].given_label
		assert_equal '--delete', args.flags[2].given_name
		assert_equal 2, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias
		assert_equal Hash.new, args.flags[2].extras

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_flag_aliases_3

		aliases	=	[
			CLASP.Flag('--expand', aliases: [ '-x', '--x' ], extras: %w{ e x t r a })
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-x', '--delete', '--x' ], aliases

		assert_equal 4, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias
		assert_equal Hash.new, args.flags[0].extras
		assert_equal '--expand', args.flags[1].to_s
		assert_equal '--expand', args.flags[1].name
		assert_equal 'x', args.flags[1].given_label
		assert_equal '-x', args.flags[1].given_name
		assert_equal 1, args.flags[1].given_hyphens
		assert_equal aliases[0], args.flags[1].argument_alias
		assert_equal [ 'e', 'x', 't', 'r', 'a' ], args.flags[1].extras
		assert_equal '--delete', args.flags[2].to_s
		assert_equal '--delete', args.flags[2].name
		assert_equal 'delete', args.flags[2].given_label
		assert_equal '--delete', args.flags[2].given_name
		assert_equal 2, args.flags[2].given_hyphens
		assert_nil args.flags[2].argument_alias
		assert_equal Hash.new, args.flags[2].extras
		assert_equal '--expand', args.flags[3].to_s
		assert_equal '--expand', args.flags[3].name
		assert_equal 'x', args.flags[3].given_label
		assert_equal '--x', args.flags[3].given_name
		assert_equal 2, args.flags[3].given_hyphens
		assert_equal aliases[0], args.flags[3].argument_alias
		assert_equal [ 'e', 'x', 't', 'r', 'a' ], args.flags[3].extras

		assert_equal 0, args.options.size

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_aliases_1

		aliases	=	[
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-o=value' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 1, args.options.size
		assert_equal '-o=value', args.options[0].to_s
		assert_equal '-o', args.options[0].name
		assert_equal 'o', args.options[0].given_label
		assert_equal 'value', args.options[0].value
		assert_equal '-o', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_equal Hash.new, args.options[0].extras

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_aliases_2

		aliases	=	[
			CLASP.Option('--option', aliases: [ '-o' ])
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-o=value' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 1, args.options.size
		assert_equal '--option=value', args.options[0].to_s
		assert_equal '--option', args.options[0].name
		assert_equal 'o', args.options[0].given_label
		assert_equal 'value', args.options[0].value
		assert_equal '-o', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_equal Hash.new, args.options[0].extras

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_aliases_3

		aliases	=	[
			CLASP.Option('--option', aliases: [ '-o' ])
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-o', 'value' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 1, args.options.size
		assert_equal '--option=value', args.options[0].to_s
		assert_equal '--option', args.options[0].name
		assert_equal 'o', args.options[0].given_label
		assert_equal 'value', args.options[0].value
		assert_equal '-o', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_equal Hash.new, args.options[0].extras

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_default_aliases_1

		aliases	=	[
			CLASP.Option('--option', aliases: [ '-o' ]),
			CLASP.Option('--option=special-value', alias: '-s')
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-o', 'value', '-s', '-s=explicit-value' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-f1', args.flags[0].to_s
		assert_equal '-f1', args.flags[0].name
		assert_equal 'f1', args.flags[0].given_label
		assert_equal '-f1', args.flags[0].given_name
		assert_equal 1, args.flags[0].given_hyphens
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 3, args.options.size
		assert_equal '--option=value', args.options[0].to_s
		assert_equal '--option', args.options[0].name
		assert_equal 'o', args.options[0].given_label
		assert_equal 'value', args.options[0].value
		assert_equal '-o', args.options[0].given_name
		assert_equal 1, args.options[0].given_hyphens
		assert_equal Hash.new, args.options[0].extras
		assert_equal '--option=special-value', args.options[1].to_s
		assert_equal '--option', args.options[1].name
		assert_equal 's', args.options[1].given_label
		assert_equal 'special-value', args.options[1].value
		assert_equal '-s', args.options[1].given_name
		assert_equal 1, args.options[1].given_hyphens
		assert_equal Hash.new, args.options[1].extras
		assert_equal '--option=explicit-value', args.options[2].to_s
		assert_equal '--option', args.options[2].name
		assert_equal 's', args.options[2].given_label
		assert_equal 'explicit-value', args.options[2].value
		assert_equal '-s', args.options[2].given_name
		assert_equal 1, args.options[2].given_hyphens
		assert_equal Hash.new, args.options[2].extras

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end

	def test_option_default_aliases_2

		aliases	=	[
			CLASP.Option('--option', aliases: [ '-o' ]),
			CLASP.Flag('--option=special-value', alias: '-s'),
			CLASP.Flag('--verbose', alias: '-v'),
		]
		args	=	CLASP::Arguments.new [ '-f1', 'value1', '-o', 'value', '-sv', '-s=explicit-value' ], aliases

		assert_equal 2, args.flags.size
		flag = args.flags[0]
		assert_equal '-f1', flag.to_s
		assert_equal '-f1', flag.name
		assert_equal 'f1', flag.given_label
		assert_equal '-f1', flag.given_name
		assert_equal 1, flag.given_hyphens
		assert_equal Hash.new, flag.extras
		assert_equal 0, flag.given_index
		flag = args.flags[1]
		assert_equal '--verbose', flag.to_s
		assert_equal '--verbose', flag.name
		assert_equal 'sv', flag.given_label
		assert_equal '-sv', flag.given_name
		assert_equal 1, flag.given_hyphens
		assert_equal Hash.new, flag.extras
		assert_equal 4, flag.given_index

		assert_equal 3, args.options.size
		option = args.options[0]
		assert_equal '--option=value', option.to_s
		assert_equal '--option', option.name
		assert_equal 'o', option.given_label
		assert_equal 'value', option.value
		assert_equal '-o', option.given_name
		assert_equal 1, option.given_hyphens
		assert_equal Hash.new, option.extras
		assert_equal 2, option.given_index
		option = args.options[1]
		assert_equal '--option=special-value', option.to_s
		assert_equal '--option', option.name
		assert_equal 'sv', option.given_label
		assert_equal 'special-value', option.value
		assert_equal '-sv', option.given_name
		assert_equal 1, option.given_hyphens
		assert_equal Hash.new, option.extras
		assert_equal 4, option.given_index
		option = args.options[2]
		assert_equal '--option=explicit-value', option.to_s
		assert_equal '--option', option.name
		assert_equal 's', option.given_label
		assert_equal 'explicit-value', option.value
		assert_equal '-s', option.given_name
		assert_equal 1, option.given_hyphens
		assert_equal Hash.new, option.extras
		assert_equal 5, option.given_index

		assert_equal 1, args.values.size
		assert_equal 'value1', args.values[0]
	end
end

