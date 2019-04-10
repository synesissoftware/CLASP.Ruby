# CLASP.Ruby Example - **show_usage_and_version**

## Summary

Example illustrating various kinds of *flag* and *option* aliases, including the combination of short-names.

## Source

```ruby
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

    sys.exit(1)
end
```

## Usage

### No arguments

If executed with no arguments

```
    ruby examples/flag_and_option_aliases.rb
```

or (in a Unix shell):

```
    ./examples/flag_and_option_aliases.rb
```

it gives the output:

```
```

### Show usage

If executed with the arguments

```
    ruby examples/flag_and_option_aliases.rb --help
```

it gives the output:

```
CLASP.Ruby examples
flag_and_option_aliases.rb 0.0.1
Illustrates use of CLASP.Ruby's use of flags, options, and aliases

USAGE: flag_and_option_aliases.rb [ ... flags and options ... ]

flags/options:

	-d
	--debug
		runs in Debug mode

	-c --verbosity=chatty
	-v <value>
	--verbosity=<value>
		specifies the verbosity
		where <value> one of:
			terse
			quiet
			silent
			chatty

	--help
		shows this help and terminates

	--version
		shows version and terminates
```

### Specify flags and options in long-form

If executed with the arguments

```
    ruby examples/flag_and_option_aliases.rb --debug --verbosity=silent
```

it gives the output:

```
verbosity is specified as: silent
Debug mode is specified
```

### Specify flags and options in short-form

If executed with the arguments

```
    ruby examples/flag_and_option_aliases.rb -v silent -d
```

it gives the (same) output:

```
verbosity is specified as: silent
Debug mode is specified
```

### Specify flags and options in short-form, including an alias for an option-with-value

If executed with the arguments

```
    ruby examples/flag_and_option_aliases.rb -c -d
```

it gives the output:

```
verbosity is specified as: chatty
Debug mode is specified
```

### Specify flags and options with combined short-form

If executed with the arguments

```
    ruby examples/flag_and_option_aliases.rb -dc
```

it gives the (same) output:

```
verbosity is specified as: chatty
Debug mode is specified
```
