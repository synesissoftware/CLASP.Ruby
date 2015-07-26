# ######################################################################### #
# File:         clasp/cli.rb
#
# Purpose:      Command-line interface
#
# Created:      27th July 2015
# Updated:      27th July 2015
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


# ######################################################################### #
# module

module Clasp

# ######################################################################### #
# methods

#
# options:
#  +:exit+                                 - a program exit code; exit() not called if not specified
#  +:program_name+                         - program name; inferred from +$0+ if not specified
#  +:stream+                               - output stream; +$stdout+ if not specified
#  +:suppress_blank_lines_between_options+ - does exactly what it says on the tin
#  +:values+                               - appends this string to USAGE line if specified
def self.show_usage aliases, options={}

	stream			=	options[:stream] || $stdout
	program_name	=	options[:program_name] || File.basename($0)

	stream.puts "USAGE: #{program_name} [ ... flags and options ... ] #{options[:values]}"
	stream.puts
	stream.puts "flags/options:"
	stream.puts
	aliases.each do |a|

		case a
		when Flag
			a.aliases.each { |al| stream.puts "\t#{al}" }
			stream.puts "\t#{a.name}"
		when Option
			a.aliases.each { |al| stream.puts "\t#{al} <value>" }
			stream.puts "\t#{a.name}=<value>"
		end
		stream.puts "\t\t#{a.help}"
		stream.puts unless options[:suppress_blank_lines_between_options]
	end

	exit options[:exit] if options[:exit]
end

# ######################################################################### #
# module

end # module Clasp

# ############################## end of file ############################# #


