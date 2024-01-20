#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_defaults < Test::Unit::TestCase

    def test_responds_to_Help

        assert CLASP::Flag.respond_to? :Help
    end

    def test_Help_is_idempotent

        help_1  =   CLASP::Flag.Help
        help_2  =   CLASP::Flag.Help

        assert_same help_1, help_2
    end

    def test_Help_attributes

        assert_equal '--help', CLASP::Flag.Help.name

        assert_equal [], CLASP::Flag.Help.aliases

        assert_equal 'shows this help and terminates', CLASP::Flag.Help.help
    end

    def test_Help_extras

        help1   =   CLASP::Flag.Help
        help2   =   CLASP::Flag.Help(v1: 'v', v2: 2)

        assert_equal Hash.new, help1.extras
        assert_equal Hash[ [ [ :v1, 'v' ], [ :v2, 2 ] ] ], help2.extras
    end

    def test_responds_to_Version

        assert CLASP::Flag.respond_to? :Version
    end

    def test_Version_is_idempotent

        version_1   =   CLASP::Flag.Version
        version_2   =   CLASP::Flag.Version

        assert_same version_1, version_2
    end

    def test_Version_attributes

        assert_equal '--version', CLASP::Flag.Version.name

        assert_equal [], CLASP::Flag.Version.aliases

        assert_equal 'shows version and terminates', CLASP::Flag.Version.help
    end

    def test_Version_extras

        version1    =   CLASP::Flag.Version
        version2    =   CLASP::Flag.Version(v1: 'v', v2: 2)

        assert_equal Hash.new, version1.extras
        assert_equal Hash[ [ [ :v1, 'v' ], [ :v2, 2 ] ] ], version2.extras
    end
end

