#!/usr/bin/env ruby

# examples/flag_and_option_specifications.rb

# requires

require 'clasp'

# constants

ProgramVersion = [ 0, 0, 1 ]

InfoLines = [

  'CLASP.Ruby examples',
  :version,
  "Illustrates use of CLASP.Ruby's use of flags, options, and aliases",
  '',
]

# Specify specifications, parse, and checking standard flags

Flag_Debug = CLASP.Flag('--debug', alias: '-d', help: 'runs in Debug mode')
Option_Verbosity = CLASP.Option('--verbosity', alias: '-v', help: 'specifies the verbosity', values: [ 'terse', 'quiet', 'silent', 'chatty' ], default_value: 'terse')
Flag_Chatty = CLASP.Flag('--verbosity=chatty', alias: '-c')

Specifications = [

  Flag_Debug,
  Option_Verbosity,
  Flag_Chatty,

  CLASP::FlagSpecification.Help,
  CLASP::FlagSpecification.Version,
]

args = CLASP::Arguments.new ARGV, Specifications

if args.flags.include?(CLASP::FlagSpecification.Help)

  CLASP.show_usage(Specifications, exit_code: 0, version: ProgramVersion, stream: $stdout, info_lines: InfoLines, default_indicator: '*default*')
end

if args.flags.include?('--version')

  CLASP.show_version(Specifications, exit_code: 0, version: ProgramVersion, stream: $stdout)
end


# Program-specific processing of flags/options

if (opt = args.find_option('--verbosity'))

  $stdout.puts "verbosity is specified as: #{opt.value}"
end

if args.flags.include?('--debug')

  $stdout.puts 'Debug mode is specified'
end



# Check for any unrecognised flags or options

if (unused = args.find_first_unknown())

  $stderr.puts "#{args.program_name}: unrecognised flag/option: #{unused}"

  exit 1
end



