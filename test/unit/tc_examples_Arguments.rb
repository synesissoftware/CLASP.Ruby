#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Examples < Test::Unit::TestCase

    def test_SimpleCommandLineNoSpecifications

        argv = %w{ --show-all=true infile -c outfile }

        args = CLASP::Arguments.new(argv)

        assert_equal 1, args.flags.size
        flag = args.flags[0]
        assert_equal "-c", flag.name
        assert_equal 1, args.options.size
        option = args.options[0]
        assert_equal "--show-all", option.name
        assert_equal "true", option.value
        assert_equal 2, args.values.size
        assert_equal "infile", args.values[0]
        assert_equal "outfile", args.values[1]
    end

    def test_UseOfSpecialDoubleSlashFlagToTreatAllSubsequentArgumentsAsValues

        argv = %w{ --show-all=true -- infile outfile -c }

        args = CLASP::Arguments.new(argv)

        assert_equal 0, args.flags.size
        option = args.options[0]
        assert_equal "--show-all", option.name
        assert_equal "true", option.value
        assert_equal 3, args.values.size
        assert_equal "infile", args.values[0]
        assert_equal "outfile", args.values[1]
        assert_equal "-c", args.values[2]
    end

    def test_UseOfFlagShortForms

        specifications = [

            CLASP.Flag('--verbose', alias: '-v'),
            CLASP.Flag('--trace-output', aliases: [ '-t', '--trace' ]),
        ]

        argv = %w{ --trace -v }

        args = CLASP::Arguments.new(argv, specifications)

        assert_equal 2, args.flags.size
        flag = args.flags[0]
        assert_equal '--trace-output', flag.name
        assert_equal '--trace', flag.given_name
        flag = args.flags[1]
        assert_equal '--verbose', flag.name
        assert_equal '-v', flag.given_name
        assert_equal 0, args.options.size
        assert_equal 0, args.values.size
    end

    def test_UseOfFlagSingleShortFormsCombined

        specifications = [

            CLASP.Flag('--expand', alias: '-x'),
            CLASP.Flag('--verbose', alias: '-v'),
            CLASP.Flag('--trace-output', aliases: [ '-t', '--trace' ]),
        ]

        argv = %w{ -tvx }

        args = CLASP::Arguments.new(argv, specifications)

        assert_equal 3, args.flags.size
        flag = args.flags[0]
        assert_equal '--trace-output', flag.name
        assert_equal '-tvx', flag.given_name
        flag = args.flags[1]
        assert_equal '--verbose', flag.name
        assert_equal '-tvx', flag.given_name
        flag = args.flags[2]
        assert_equal '--expand', flag.name
        assert_equal '-tvx', flag.given_name
        assert_equal 0, args.options.size
        assert_equal 0, args.values.size
    end

    def test_UseOfOptionShortForm

        specifications = [

            CLASP.Option('--show-all', alias: '-a'),
        ]

        argv = %w{ -c -a true infile outfile }

        args = CLASP::Arguments.new(argv, specifications)

        assert_equal 1, args.flags.size
        flag = args.flags[0]
        assert_equal "-c", flag.name
        assert_equal 1, args.options.size
        option = args.options[0]
        assert_equal "--show-all", option.name
        assert_equal "-a", option.given_name
        assert_equal "true", option.value
        assert_equal 2, args.values.size
        assert_equal "infile", args.values[0]
        assert_equal "outfile", args.values[1]
    end

    def test_UseOfFlagsAsSpecificationsForOption

        specifications = [

            CLASP.Flag('--dump-contents', alias: '-d'),
            CLASP.Option('--log-level', alias: '-l'),
            CLASP.Flag('--log-level=warning', alias: '-w'),
        ]

        argv = %w{ myfile -dw }

        args = CLASP::Arguments.new(argv, specifications)

        assert_equal 1, args.flags.size
        flag = args.flags[0]
        assert_equal "--dump-contents", flag.name
        assert_equal "-dw", flag.given_name
        assert_equal 1, flag.given_index
        assert_equal 1, args.options.size
        option = args.options[0]
        assert_equal "--log-level", option.name
        assert_equal "-dw", option.given_name
        assert_equal 1, flag.given_index
        assert_equal "warning", option.value
        assert_equal 1, args.values.size
        assert_equal "myfile", args.values[0]
    end
end

