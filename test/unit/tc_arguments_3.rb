#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Arguments_3 < Test::Unit::TestCase

    def test_include_flag_1

        args = CLASP::Arguments.new [ '-f1', 'value1', '--option1=value1', '--flag2' ], nil

        assert args.flags.include? '-f1'
        assert not(args.flags.include? '-f2')
        assert args.flags.include? '--flag2'
        assert not(args.flags.include? '--option1')
    end

    def test_include_flag_2

        aliases = [
            CLASP.Flag('--flag1', alias: '-f1'),
        ]
        args = CLASP::Arguments.new [ '-f1', 'value1', '--option1=value1', '--flag2' ], aliases

        assert args.flags.include? '-f1'
        assert args.flags.include? '--flag1'
        assert not(args.flags.include? '-f2')
        assert args.flags.include? '--flag2'
        assert not(args.flags.include? '--option1')
    end

    def test_combined_flags_1

        aliases = [
            CLASP.Flag('--delete', alias: '-d'),
            CLASP.Flag('--update', alias: '-u'),
        ]
        args = CLASP::Arguments.new [ '-du' ], aliases

        assert args.flags.include? '--delete'
        assert args.flags.include? '--update'
    end

    def test_get_option_1

        args = CLASP::Arguments.new [ '-f1', 'value1', '--option1=value1', '--flag2' ], nil

        assert args.options.include? '--option1'
        assert not(args.options.include? '--option1=value1')
        assert not(args.options.include? '-f1')
        assert not(args.options.include? '--flag2')
    end

    def test_get_option_2

        aliases = [
            CLASP.Flag('--flag1', alias: '-f1'),
            CLASP.Option('--option1', alias: '-o1'),
        ]
        args = CLASP::Arguments.new [ '-f1', 'value1', '-o1=value1', '--flag2' ], aliases

        assert args.options.include? '-o1'
        assert args.options.include? '--option1'
        assert not(args.options.include? '--option1=value1')
        assert not(args.options.include? '-f1')
        assert not(args.options.include? '--flag2')
    end

    def test_combined_flags_and_options_1

        aliases = [
            CLASP.Flag('--delete', alias: '-d'),
            CLASP.Flag('--update', alias: '-u'),
            CLASP.Option('--encryption', alias: '-e'),
            CLASP.Option('--encryption=blowfish', alias: '-b'),
        ]
        args = CLASP::Arguments.new [ '-du', '-e', 'sha' ], aliases

        assert args.flags.include? '--delete'
        assert args.flags.include? '--update'
        assert args.options.include? '--encryption'
        assert_not_nil args.options.detect { |o| o == '--encryption' }
        assert_nil args.options.detect { |o| o == '--blah' }
    end
end

