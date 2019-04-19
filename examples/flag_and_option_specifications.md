# CLASP.Ruby Example - **flag_and_option_specifications**

## Summary

Example illustrating various kinds of *flag* and *option* specifications, including the combination of short-names.

## Source

```ruby
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
```

## Usage

### No arguments

If executed with no arguments

```
    ruby examples/flag_and_option_specifications.rb
```

or (in a Unix shell):

```
    ./examples/flag_and_option_specifications.rb
```

it gives the output:

```
```

### Show usage

If executed with the arguments

```
    ruby examples/flag_and_option_specifications.rb --help
```

it gives the output:

```
CLASP.Ruby examples
flag_and_option_specifications.rb 0.0.1
Illustrates use of CLASP.Ruby's use of flags, options, and aliases

USAGE: flag_and_option_specifications.rb [ ... flags and options ... ]

flags/options:

	-d
	--debug
		runs in Debug mode

	-c --verbosity=chatty
	-v <value>
	--verbosity=<value>
		specifies the verbosity
		where <value> one of:
			terse	*default*
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
    ruby examples/flag_and_option_specifications.rb --debug --verbosity=silent
```

it gives the output:

```
verbosity is specified as: silent
Debug mode is specified
```

### Specify flags and options in short-form

If executed with the arguments

```
    ruby examples/flag_and_option_specifications.rb -v silent -d
```

it gives the (same) output:

```
verbosity is specified as: silent
Debug mode is specified
```

### Specify flags and options in short-form, including an alias for an option-with-value

If executed with the arguments

```
    ruby examples/flag_and_option_specifications.rb -c -d
```

it gives the output:

```
verbosity is specified as: chatty
Debug mode is specified
```

### Specify flags and options with combined short-form

If executed with the arguments

```
    ruby examples/flag_and_option_specifications.rb -dc
```

it gives the (same) output:

```
verbosity is specified as: chatty
Debug mode is specified
```

### Utilise the default value for verbosity

If executed with the arguments

```
    ruby examples/flag_and_option_specifications.rb -d --verbosity=
```

it gives the output:

```
verbosity is specified as: terse
Debug mode is specified
```


