#!/usr/bin/env ruby

# examples/show_usage_and_version.rb

# requires

require 'clasp'

# constants

ProgramVersion = [ 0, 0, 1 ]

InfoLines = [

    'CLASP.Ruby examples',
    :version,
    "Illustrates use of CLASP.Ruby's CLASP.show_usage() and CLASP.show_version() methods",
    '',
]

# Specify specifications, parse, and checking standard flags

Specifications = [

    CLASP::FlagSpecification.Help,
    CLASP::FlagSpecification.Version,
]

args = CLASP::Arguments.new ARGV, Specifications

if args.flags.include?('--help')

    CLASP.show_usage(Specifications, exit_code: 0, version: ProgramVersion, stream: $stdout, info_lines: InfoLines)
end

if args.flags.include?('--version')

    CLASP.show_version(Specifications, exit_code: 0, version: ProgramVersion, stream: $stdout)
end


# Check for any unrecognised flags or options

if (unused = args.find_first_unknown())

	$stderr.puts "#{args.program_name}: unrecognised flag/option: #{unused}"

    exit 1
end


$stdout.puts 'no flags specified'


