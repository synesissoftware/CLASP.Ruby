# CLASP.Ruby Example - **show_usage_and_version**

## Summary

Simple example supporting ```--help``` and ```--version```.

## Source

```ruby
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

# Specify aliases, parse, and checking standard flags

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

    sys.exit(1)
end


$stdout.puts 'no flags specified'
```

## Usage

### No arguments

If executed with no arguments

```
    ruby examples/show_usage_and_version.rb
```

or (in a Unix shell):

```
    ./examples/show_usage_and_version.rb
```

it gives the output:

```
no flags specified
```

### Show usage

If executed with the arguments

```
    ruby examples/show_usage_and_version.rb --help
```

it gives the output:

```
CLASP.Ruby examples
show_usage_and_version.rb 0.0.1
Illustrates use of CLASP.Ruby's show_usage() and show_version() methods

USAGE: show_usage_and_version.rb [ ... flags and options ... ]

flags/options:

	--help
		Shows usage and terminates

	--version
		Shows version and terminates
```

### Show version

If executed with the arguments

```
    ruby examples/show_usage_and_version.rb --version
```

it gives the output:

```
show_usage_and_version.rb 0.0.1
```

### Unknown option

If executed with the arguments

```
    ruby examples/show_usage_and_version.rb --unknown=value
```

it gives the output (on the standard error stream):

```
show_usage_and_version.rb: unrecognised flag/option: --unknown=value
```

with an exit code of 1

