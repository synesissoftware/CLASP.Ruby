#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

require 'stringio'

class Test_Usage < Test::Unit::TestCase

  def test_empty_default

    specifications = []

    stream = StringIO.new

    CLASP.show_usage specifications, stream: stream, program_name: 'myprog'

    expected = <<EOF_output
USAGE: myprog [ ... flags and options ... ]

EOF_output
    actual = stream.string

    assert_equal expected, actual
  end

  def test_empty_all

    specifications = []

    stream = StringIO.new

    CLASP.show_usage specifications, stream: stream, program_name: 'myprog', flags_and_options: ''

    expected = <<EOF_output
USAGE: myprog

EOF_output
    actual = stream.string

    assert_equal expected, actual
  end

  def test_empty_all_with_info_line_of_one_string

    specifications = []

    stream  = StringIO.new

    info    = 'myprog version'.freeze

    CLASP.show_usage specifications, stream: stream, program_name: 'myprog', flags_and_options: '', info_lines: info

    expected = <<EOF_output
myprog version
USAGE: myprog

EOF_output
    actual = stream.string

    assert_equal expected, actual
  end

  def test_empty_all_with_info_lines

    specifications = []

    stream = StringIO.new

    info_lines = [

        'Synesis Software My Program',
        'version 1',
    ].freeze

    CLASP.show_usage specifications, stream: stream, program_name: 'myprog', flags_and_options: '', info_lines: info_lines

    expected = <<EOF_output
Synesis Software My Program
version 1
USAGE: myprog

EOF_output
    actual = stream.string

    assert_equal expected, actual
  end

  def test_empty_all_with_info_lines_including_version

    specifications = []

    stream = StringIO.new

    info_lines = [

      'Synesis Software My Program',
      :version
    ].freeze

    CLASP.show_usage specifications, stream: stream, program_name: 'myprog', flags_and_options: '', info_lines: info_lines, version: [ 1, 0, 1], version_prefix: 'v'

    expected = <<EOF_output
Synesis Software My Program
myprog v1.0.1
USAGE: myprog

EOF_output
    actual = stream.string

    assert_equal expected, actual
  end

  def test_one_alias_default

    specifications = [

      CLASP::Flag.Version
    ]

    stream = StringIO.new

    CLASP.show_usage specifications, stream: stream, program_name: 'myprog'

    expected = <<EOF_output
USAGE: myprog [ ... flags and options ... ]

flags/options:

\t--version
\t\t#{CLASP::Flag.Version.help}

EOF_output
    actual = stream.string

    assert_equal expected, actual
  end

  def test_one_alias_all

    specifications = [

        CLASP::Flag.Version
    ]

    stream = StringIO.new

    CLASP.show_usage specifications, stream: stream, program_name: 'myprog', flags_and_options: ''

    expected = <<EOF_output
USAGE: myprog

flags/options:

\t--version
\t\t#{CLASP::Flag.Version.help}

EOF_output
    actual = stream.string

    assert_equal expected, actual
  end
end

