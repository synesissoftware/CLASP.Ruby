#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Option_required < Test::Unit::TestCase

    def test_Option_required_false_implicit

        o = CLASP.Option('--verbose')

        assert_equal '--verbose', o.name
        assert_equal [], o.aliases
        assert_equal [], o.values_range
        assert_equal nil, o.default_value
        assert_equal ({}), o.extras
        assert !o.required?
        assert_equal "'--verbose' not specified; use --help for usage", o.required_message
    end

    def test_Option_required_false_explicit

        o = CLASP.Option('--verbose', required: false, required_message: "\0Verbosity")

        assert_equal '--verbose', o.name
        assert_equal [], o.aliases
        assert_equal [], o.values_range
        assert_equal nil, o.default_value
        assert_equal ({}), o.extras
        assert !o.required?
        assert_equal "Verbosity not specified; use --help for usage", o.required_message
    end

    def test_Option_required_true

        o = CLASP.Option('--verbose', required: true, required_message: 'Verbosity not given')

        assert_equal '--verbose', o.name
        assert_equal [], o.aliases
        assert_equal [], o.values_range
        assert_equal nil, o.default_value
        assert_equal ({}), o.extras
        assert o.required?
        assert_equal "Verbosity not given", o.required_message
    end
end

