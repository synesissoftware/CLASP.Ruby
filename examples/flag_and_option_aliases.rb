#!/usr/bin/env ruby

# examples/flag_and_option_aliases.rb

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

# Specify aliases, parse, and checking standard flags

Flag_Debug = CLASP.Flag('--debug', alias: '-d', help: 'runs in Debug mode')
Option_Verbosity = CLASP.Option('--verbosity', alias: '-v', help: 'specifies the verbosity', values: [ 'terse', 'quiet', 'silent', 'chatty' ])
Flag_Chatty = CLASP.Flag('--verbosity=chatty', alias: '-c')

Aliases = [

	Flag_Debug,
	Option_Verbosity,
	Flag_Chatty,

    CLASP::FlagAlias.Help,
    CLASP::FlagAlias.Version,
]

args = CLASP::Arguments.new ARGV, Aliases

if args.flags.include?(CLASP::FlagAlias.Help)

    CLASP.show_usage(Aliases, exit_code: 0, version: ProgramVersion, stream: $stdout, info_lines: InfoLines)
end

if args.flags.include?('--version')

    CLASP.show_version(Aliases, exit_code: 0, version: ProgramVersion, stream: $stdout)
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



