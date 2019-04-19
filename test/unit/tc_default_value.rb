#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

require 'xqsr3/extensions/test/unit'

class Test_DefaultValue < Test::Unit::TestCase

	def test_long_form_without_default

		specifications	=	[

			CLASP.Option('--verbosity', values: [ 'silent', 'terse', 'normal', 'chatty', 'verbose' ])
		]

		argv	=	[ '--verbosity' ]
		args	=	CLASP::Arguments.new(argv, specifications)

		assert_equal 0, args.flags.size
		assert_equal 1, args.options.size
		assert_equal 0, args.values.size

		option0	=	args.options[0]

		assert_equal '--verbosity', option0.name
		assert_nil option0.value
	end

	def test_long_form_with_default

		specifications	=	[

			CLASP.Option('--verbosity', values: [ 'silent', 'terse', 'normal', 'chatty', 'verbose' ], default_value: 'normal')
		]

		argv	=	[ '--verbosity' ]
		args	=	CLASP::Arguments.new(argv, specifications)

		assert_equal 0, args.flags.size
		assert_equal 1, args.options.size
		assert_equal 0, args.values.size

		option0	=	args.options[0]

		assert_equal '--verbosity', option0.name
		assert_equal 'normal', option0.value
	end

	def test_short_form_without_default

		specifications	=	[

			CLASP.Option('--verbosity', alias: '-v', values: [ 'silent', 'terse', 'normal', 'chatty', 'verbose' ])
		]

		argv	=	[ '-v' ]
		args	=	CLASP::Arguments.new(argv, specifications)

		assert_equal 0, args.flags.size
		assert_equal 1, args.options.size
		assert_equal 0, args.values.size

		option0	=	args.options[0]

		assert_equal '--verbosity', option0.name
		assert_nil option0.value
	end

	def test_short_form_with_default

		specifications	=	[

			CLASP.Option('--verbosity', alias: '-v', values: [ 'silent', 'terse', 'normal', 'chatty', 'verbose' ], default_value: 'normal')
		]

		argv	=	[ '-v' ]
		args	=	CLASP::Arguments.new(argv, specifications)

		assert_equal 0, args.flags.size
		assert_equal 1, args.options.size
		assert_equal 0, args.values.size

		option0	=	args.options[0]

		assert_equal '--verbosity', option0.name
		assert_equal 'normal', option0.value
	end

	def test_short_form_without_default_and_separator

		specifications	=	[

			CLASP.Option('--verbosity', alias: '-v', values: [ 'silent', 'terse', 'normal', 'chatty', 'verbose' ])
		]

		argv	=	[ '-v', '--', 'some-value' ]
		args	=	CLASP::Arguments.new(argv, specifications)

		assert_equal 0, args.flags.size
		assert_equal 1, args.options.size
		assert_equal 1, args.values.size

		option0	=	args.options[0]

		assert_equal '--verbosity', option0.name
		assert_nil option0.value
	end

	def test_short_form_with_default_and_separator

		specifications	=	[

			CLASP.Option('--verbosity', alias: '-v', values: [ 'silent', 'terse', 'normal', 'chatty', 'verbose' ], default_value: 'normal')
		]

		argv	=	[ '-v', '--', 'some-value' ]
		args	=	CLASP::Arguments.new(argv, specifications)

		assert_equal 0, args.flags.size
		assert_equal 1, args.options.size
		assert_equal 1, args.values.size

		option0	=	args.options[0]

		assert_equal '--verbosity', option0.name
		assert_equal 'normal', option0.value
	end
end

