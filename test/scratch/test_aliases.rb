
$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'
require 'recls'

Aliases = [

	CLASP.Flag('--help', :help => 'shows this help and quits'),
	CLASP.Flag('--version', :alias => '-v', :help => 'shows this version and quits'),

	CLASP.Option('--directory', :alias => '-d', :help => 'a directory within which to process'),
	CLASP.Option('--patterns', :alias => '-p', :help => "one or more patterns, separated by '|' or '#{Recls::PATH_SEPARATOR}', against which the entries will be matched"),

	CLASP.Option('--case-sensitive', :alias => '-c', :help => 'determines whether case sensitive', :values_range => %W{ yes no true false }, :default_value => false),
]

Arguments	=	CLASP::Arguments.new(ARGV, Aliases)
Flags		=	Arguments.flags
Options		=	Arguments.options
Values		=	Arguments.values

#Arguments.aliases.each do |a|
#
#	puts a.inspect
#end

Flags.each do |f|

	puts f.inspect
end

Options.each do |o|

	puts o.inspect
end

