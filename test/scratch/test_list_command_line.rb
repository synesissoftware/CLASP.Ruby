
$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Aliases = [

	Clasp.Flag('--help', :help => 'shows this help and quits'),
	Clasp.Flag('--version', :alias => '-v', :help => 'shows this version and quits'),

	Clasp.Option('--verbosity', :aliases => %w{ -V --verbose }),
]

Args = Clasp::Arguments.new(ARGV, Aliases)

puts
puts "flags #{Args.flags.size}:"
Args.flags.each do |flag|

	puts "\t#{flag}\t[#{flag.index}, #{flag.given_name}, #{flag.argument_alias}, #{flag.given_hyphens}, #{flag.label}, #{flag.name}]"
end

puts
puts "options #{Args.options.size}:"
Args.options.each do |option|

	puts "\t#{option}\t[#{option.index}, #{option.given_name}, #{option.argument_alias}, #{option.given_hyphens}, #{option.label}, #{option.name}, #{option.value}]"
end

puts
puts "values #{Args.values.size}:"
Args.values.each do |value|

	puts "\t#{value}"
end

