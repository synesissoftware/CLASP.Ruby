
$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Args = Clasp::Arguments::new(ARGV)

puts
puts "flags #{Args.flags.size}:"
Args.flags.each do |flag|

	puts "\t#{flag}\t[#{flag.num_hyphens}, #{flag.name}]"
end

puts
puts "options #{Args.options.size}:"
Args.options.each do |option|

	puts "\t#{option}\t[#{option.num_hyphens}, #{option.name}, #{option.value}]"
end

puts
puts "values #{Args.values.size}:"
Args.values.each do |value|

	puts "\t#{value}"
end

