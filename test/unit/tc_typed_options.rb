#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'xqsr3/extensions/test/unit' if RUBY_VERSION >= '2'

require 'test/unit'

class Test_TypedOptionValues < Test::Unit::TestCase

  if RUBY_VERSION < '2'

    def assert_raise_with_message(type_spec, message_spec, *args, &block)

      assert_raise(type_spec, *args, &block)
    end
  end

  def test_Integer_no_range

    specifications = [

      CLASP.Option('--level', default_value: 1234, constraint: { type: Integer })
    ]

    # with no arguments
    begin

      argv = []
      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 0, args.options.size
      assert_equal 0, args.values.size
    end

    # with default value
    begin

      argv = [ '--level=' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '', opt.given_value
      assert_equal 1234, opt.value
    end

    # with explicit value 0
    begin

      argv = [ '--level=0' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '0', opt.given_value
      assert_equal 0, opt.value
    end

    # with explicit value -100
    begin

      argv = [ '--level=-100' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '-100', opt.given_value
      assert_equal(-100, opt.value)
    end

    # with explicit value 123456789
    begin

      argv = [ '--level=123456789' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '123456789', opt.given_value
      assert_equal 123456789, opt.value
    end

    # with explicit value +123456789
    begin

      argv = [ '--level=+123456789' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '+123456789', opt.given_value
      assert_equal 123456789, opt.value
    end
  end

  def test_Integer_positive

    specifications = [

      CLASP.Option('--level', default_value: 1234, constraint: { type: Integer, range: :positive })
    ]

    # with no arguments
    begin

      argv = []
      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 0, args.options.size
      assert_equal 0, args.values.size
    end

    # with default value
    begin

      argv = [ '--level=' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '', opt.given_value
      assert_equal 1234, opt.value
    end

    # with explicit value 0
    begin

      argv = [ '--level=0' ]

      assert_raise_with_message(CLASP::Exceptions::IntegerOutOfRangeException, /\b0\b.*--level.*must be a positive integer/) { CLASP.parse argv, specifications }
    end

    # with explicit value -100
    begin

      argv = [ '--level=-100' ]

      assert_raise_with_message(CLASP::Exceptions::IntegerOutOfRangeException, /-100\b.*--level.*must be a positive integer/) { CLASP.parse argv, specifications }
    end

    # with explicit value 123456789
    begin

      argv = [ '--level=123456789' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '123456789', opt.given_value
      assert_equal 123456789, opt.value
    end

    # with explicit value +123456789
    begin

      argv = [ '--level=+123456789' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '+123456789', opt.given_value
      assert_equal 123456789, opt.value
    end
  end

  def test_Integer_range_values_range

    specifications = [

      CLASP.Option('--level', default_value: 1234, values_range: [ 1234, -1234, 7, 19 ], constraint: { type: Integer })
    ]

    # with no arguments
    begin

      argv = []
      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 0, args.options.size
      assert_equal 0, args.values.size
    end

    # with default value
    begin

      argv = [ '--level=' ]

      args = CLASP.parse argv, specifications

      assert_equal 0, args.flags.size
      assert_equal 1, args.options.size
      assert_equal 0, args.values.size

      opt = args.options[0]

      assert_equal 0, opt.given_index
      assert_equal specifications[0], opt.argument_specification
      assert_equal '--level', opt.name
      assert_equal '', opt.given_value
      assert_equal 1234, opt.value
    end

    # with explicit value 0
    begin

      argv = [ '--level=0' ]

      assert_raise_with_message(CLASP::Exceptions::IntegerOutOfRangeException, /\b0\b.*--level.*does not fall within the required range/) { CLASP.parse argv, specifications }
    end

    spec0   = specifications[0]
    values  = spec0.values_range.sort[0]..spec0.values_range.sort[-1]

    values.each do |val|

      argv = [ "--level=#{val}" ]

      if spec0.values_range.include? val

          args = CLASP.parse argv, specifications

          assert_equal 0, args.flags.size
          assert_equal 1, args.options.size
          assert_equal 0, args.values.size

          opt = args.options[0]

          assert_equal 0, opt.given_index
          assert_equal specifications[0], opt.argument_specification
          assert_equal '--level', opt.name
          assert_equal val.to_s, opt.given_value
          assert_equal val, opt.value
      else

        assert_raise_with_message(CLASP::Exceptions::IntegerOutOfRangeException, /#{val}\b.*--level.*does not fall within the required range/) { CLASP.parse argv, specifications }
      end
    end
  end
end

