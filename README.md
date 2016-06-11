# CLASP.Ruby

## Installation & usage

Install using `gem install clasp-ruby` or add it to your `Gemfile`.

## Description

**CLASP** stands for **C**\ommand-**L**\ine **A**\rgument **S**\orting and
**P**\arsing. The first \CLASP library was a C library with a C++ wrapper. There
have been several implementations in other languages. **CLASP.Ruby** is the
Ruby version.

All \CLASP libraries provide the following facilities to **C**\ommand **L**\ine
**I**\nterface (**CLI**) programs:

#### Command-line parsing

All **CLASP** libraries discriminate between three types of command-line arguments:

 * *flags* are hyphen-prefixed arguments that are either present or absent, and hence have a boolean nature;
 * *options* are hyphen-prefixed arguments that are given values; and
 * *values* are non-hyphen-prefixed arguments that represent values.

For example, in the command line

	`myprog --all -c --opt1=val1 infile outfile`

there are:

 * two *flags*, `--all` and `-c`;
 * one *option* called `--opt1`, which has the value `val1`; and
 * two *values* `infile` and `outfile`.

*Flags* and *options* may have alias. If the alias for `--all` is `-a` and the alias for `--opt1` is `-o` then the following command-line is exactly equivalent to the previous one:

	`myprog -a -c -o val1 infile outfile`

One-letter *flags* may be combined. Hence, the following command-line is exactly equivalent to the previous ones:

	`myprog -ac -o val1 infile outfile`

Option aliases may specify a value. If the alias `-v1` means `--opt1=val1` then the following command-line is exactly equivalent to the previous ones:

	`myprog -ac -v1 infile outfile`

Option aliases that are one letter may be combined with one-letter flags. If the alias `-v` means `--opt1=val1` then the following command-line is exactly equivalent to the previous ones:

	`myprog -acv infile outfile`

UNIX standard arguments confer specific meanings:

 * `--help` means that the program should show the usage/help information and terminate;
 * `--version` means that the program should show the version information and terminate;
 * `--` means that all subsequent arguments should be treated as values, regardless of any hyphen-prefixes or embedded `=` signs.

#### Declarative specification of the flags and options for a CLI

To support such above special processing, \CLASP libraries provide facilities
for declarative specification of command-line *flags* and *options*, and
aliases thereof. For the previous example, the **CLASP.Ruby** code would look
like the following:

```ruby

# file: cr-example.rb

PROGRAM_VERSION = '0.1.2'

Aliases = [

	CLASP.Flag('--all', alias: '-a', help: 'processes all item types'),
	CLASP.Flag('-c', help: 'count the processed items'),
	CLASP.Option('--opt1', alias: '-o', help: 'an option of some kind', values_range: %w{ val1, val2 }),
	CLASP.Option('--opt1=val1', alias: '-v'),

	# see next section for why these two are here
	CLASP::Flag.Help,
	CLASP::Flag.Version,
]

# assuming the command-line `myprog -acv infile outfile`
Args = CLASP::Arguments.new(ARGV, Aliases)

puts Args.flags.size                # => 2
puts Args.flags[0].name             # => "--all"
puts Args.flags[1].name             # => "-c"

puts Args.options.size              # => 1
puts Args.options[0].name           # => "--opt1"
puts Args.options[0].value          # => "val1"

puts Args.values.size               # => 2
puts Args.values[0]                 # => "infile"
puts Args.values[1]                 # => "outfile"

```

#### Utility functions for displaying usage and version information

There are aspects common to all CLI programs, such as responding to `--help` and `--version`. All **\CLASP** libraries provide facilities to assist the programmer: **CLASP.Ruby** provides the two module methods CLASP.show_usage() and CLASP.show_version(), as shown in the following code extending the example above:

```ruby

Args.flags.each do |f|

	case f.name
	when CLASP::Flag.Help.name

		CLASP.show_usage(Aliases, exit: 0, values: '<input-file> <output-file>')
	when CLASP::Flag.Version.name

		CLASP.show_version(Aliases, exit: 0, version: PROGRAM_VERSION)
	when '--all'

		# do something appropriate to `--all`

	. . .

```

Given the command

	`./cr-example.rb --help`

then the program will output the following

```
USAGE: cr-example.rb [ ... flags and options ... ] <input-file> <output-file>

flags/options:

	-a
	--all
		processes all item types

	-c
		count the processed items

	-v --opt1=val1
	-o <value>
	--opt1=<value>
		an option of some kind where <value> one of:
			val1,
			val2

	--help
		shows this help and terminates

	--version
		shows version and terminates

```

and given the command

	`./cr-example.rb --version`

then the program will output the following

```
cr-example.rb 0.1.2
```

## Where to get help

[GitHub Page](https://github.com/synesissoftware/CLASP.Ruby "GitHub Page")

## Contribution guidelines

[The usual pull-request mechanism](https://help.github.com/articles/using-pull-requests/)

## Related projects

**CLASP.Ruby** is inspired by the [C/C++ CLASP library](https://github.com/synesissoftware/CLASP), which is documented in the articles:

 * _An Introduction to \CLASP_, Matthew Wilson, [CVu](http://accu.org/index.php/journals/c77/), January 2012;
 * _[Anatomy of a CLI Program written in C](http://synesis.com.au/publishing/software-anatomies/anatomy-of-a-cli-program-written-in-c.html)_, Matthew Wilson, [CVu](http://accu.org/index.php/journals/c77/), September 2012; and
 * _[Anatomy of a CLI Program written in C++](http://synesis.com.au/publishing/software-anatomies/anatomy-of-a-cli-program-written-in-c++.html)_, Matthew Wilson, [CVu](http://accu.org/index.php/journals/c77/), September 2015.

**CLASP.Ruby** is used in the **[libCLImate.Ruby](https://github.com/synesissoftware/libCLImate.Ruby)** library.


