
# ######################################################################## #
# File:         clasp/cli.rb
#
# Purpose:      Command-line interface
#
# Created:      27th July 2015
# Updated:      10th April 2019
#
# Home:         http://github.com/synesissoftware/CLASP.Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2015-2019, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the names of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ######################################################################## #



# ######################################################################## #
# module

=begin
=end

module CLASP

# ######################################################################## #
# helpers

=begin
=end

# :stopdoc:
module CLI_helpers_

	module Constants

		VALID_ALIAS_TYPES			=	[ FlagSpecification, OptionSpecification, Specification ]
		VALID_ALIAS_TYPES_STRING	=	VALID_ALIAS_TYPES[0...-1].join(', ') + ', or ' + VALID_ALIAS_TYPES[-1].to_s
	end # module Constants

# :nodoc:
def self.generate_version_string_ options

	program_name	=	options[:program_name] || File.basename($0)

	version_prefix	=	options[:version_prefix]

	if options[:version]

		case	options[:version]
		when	::Array
			version	=	options[:version].join('.')
		else
			version = options[:version]
		end
	else

		version_major	=	options[:version_major] or raise ArgumentError, "options must specify :version or :version_major [ + :version_minor [ + :version_revision [ + :version_build ]]]"
		version_minor	=	options[:version_minor]
		version_rev		=	options[:version_revision]
		version_build	=	options[:version_build]

		version			=	version_major.to_s
		version			+=	".#{version_minor}" if version_minor
		version			+=	".#{version_rev}" if version_rev
		version			+=	".#{version_build}" if version_build
	end

	"#{program_name} #{version_prefix}#{version}"
end

end # module CLI_helpers_

# ######################################################################## #
# methods

=begin
=end

# :startdoc:

# Displays usage for the program according to the given specifications and options
#
# === Signature
#
# * *Parameters*:
#   - +specifications+:: (+Array+) The arguments array. May not be +nil+. Defaults to +ARGV+.
#   - +options+:: An options hash, containing any of the following options.
#
# * *Options*:
#   - +:exit+::                                 a program exit code; <tt>exit()</tt> not called if not specified (or +nil+).
#   - +:program_name+::                         program name; inferred from <tt>$0</tt> if not specified.
#   - +:stream+::                               output stream; <tt>$stdout</tt> if not specified.
#   - +:suppress_blank_lines_between_options+:: does exactly what it says on the tin.
#   - +:values+::                               appends this string to USAGE line if specified.
#   - +:flags_and_options+::                    inserts a custom string instead of the default string <tt>'[ ... flags and options ... ]'</tt>.
#   - +:info_lines+::                           inserts 0+ information lines prior to the usage.
def self.show_usage specifications, options={}

	options	||=	{}

	raise ArgumentError, "specifications may not be nil" if specifications.nil?
	raise TypeError, "specifications must be an array or must respond to each, reject and select" unless ::Array === specifications || (specifications.respond_to?(:each) && specifications.respond_to?(:reject) && specifications.respond_to?(:select))

	constants		=	CLI_helpers_::Constants
	specifications.each { |a| raise ::TypeError, "each element in specifications array must be one of the types #{constants::VALID_ALIAS_TYPES_STRING}" unless constants::VALID_ALIAS_TYPES.any? { |c| c === a } }

	alias_dups = {}
	specifications.each { |a| a.aliases.each { |aa| warn "WARNING: alias '#{aa}' is already used for alias '#{a}'" if alias_dups.has_key? aa; alias_dups[aa] = a; } }

	suppress_blanks	=	options[:suppress_blank_lines_between_options] || ENV['SUPPRESS_BLANK_LINES_BETWEEN_OPTIONS']

	stream			=	options[:stream] || $stdout
	program_name	=	options[:program_name] || File.basename($0)

	info_lines		=	options[:info_lines]
	case info_lines
	when ::Array

		;
	when ::NilClass

		info_lines	=	[]
	else

		info_lines = [ info_lines ] unless [ :each, :empty? ].all? { |m| info_lines.respond_to? m }
	end
	info_lines		=	info_lines.map do |line|

		case line
		when :version

			CLI_helpers_.generate_version_string_ options
		else

			line
		end
	end

	values			=	options[:values] || ''
	values			=	" #{values}" if !values.empty? && ' ' != values[0]

	flags_and_options	=	options[:flags_and_options] || ' [ ... flags and options ... ]'
	flags_and_options	=	" #{flags_and_options}" if !flags_and_options.empty? && ' ' != flags_and_options[0]

	# sift the specifications to sort out which are value-option
	# specifications (VOAs)

	voas			=	{}

	specifications.select { |a| a.name =~ /^-+[a-zA-Z0-3_-]+[=:].+/ }.each do |a|

		a.name =~ /^(-+[a-zA-Z0-3_-]+)[=:](.+)$/

		voas[$1]	=	[] unless voas.has_key? $1
		voas[$1]	<<	[ a, $2 ]
	end

	fas				=	{}

	specifications.select { |a| Specification === a }.each do |a|

		fas[a.name]	=	[] unless fas.has_key? $1
		fas[a.name]	<<	a
	end

	specifications	=	specifications.reject { |a| a.name =~ /^-+[a-zA-Z0-3_-]+[=:].+/ }

	info_lines.each { |info_line| stream.puts info_line } unless info_lines.empty?

	stream.puts "USAGE: #{program_name}#{flags_and_options}#{values}"
	stream.puts

	unless specifications.empty?

		stream.puts "flags/options:"
		stream.puts
		specifications.each do |a|

			case a
			when Specification

				next
			when FlagSpecification

				if fas.has_key? a.name

					fas[a.name].each do |fa|

						fa.aliases.each { |al| stream.puts "\t#{al}" }
					end
				end
				a.aliases.each { |al| stream.puts "\t#{al}" }
				stream.puts "\t#{a.name}"
				stream.puts "\t\t#{a.help}"
			when OptionSpecification

				if voas.has_key? a.name

					voas[a.name].each do |ar|

						ar[0].aliases.each { |al| stream.puts "\t#{al} #{ar[0].name}" }
					end
				end
				a.aliases.each { |al| stream.puts "\t#{al} <value>" }
				stream.puts "\t#{a.name}=<value>"
				stream.puts "\t\t#{a.help}"
				unless a.values_range.empty?

					stream.puts "\t\twhere <value> one of:"
					a.values_range.each { |v| stream.puts "\t\t\t#{v}" }
				end
			end
			stream.puts unless suppress_blanks
		end
	end

	exit_code		=	options[:exit_code] || options[:exit]

	exit exit_code if exit_code
end

# Displays version for the program according to the given specifications and options
#
# === Signature
#
# * *Parameters*:
#   - +specifications+:: (+Array+) The arguments array. May not be +nil+. Defaults to +ARGV+.
#   - +options+:: An options hash, containing any of the following options.
#
# * *Options*:
#   - +:exit+::                 a program exit code; <tt>exit()</tt> not called if not specified (or +nil+).
#   - +:program_name+::         program name; inferred from <tt>$0</tt> if not specified.
#   - +:stream+::               output stream; <tt>$stdout</tt> if not specified.
#   - +:version+::              an array (of N elements, each of which will be separated by a period '.'), or a string. Must be specified if not +:version_major+.
#   - +:version_major+::        a number or string. Only considered and must be specified if +:version+ is not.
#   - +:version_minor+::        a number or string. Only considered if +:version+ is not.
#   - +:version_revision+::     a number or string. Only considered if +:version+ is not.
#   - +:version_build+::        a number or string. Only considered if +:version+ is not.
#   - +:version_prefix+::       optional string to prefix the version number(s).
def self.show_version specifications, options = {}

	options	||=	{}

	raise ArgumentError, "specifications may not be nil" if specifications.nil?
	raise TypeError, "specifications must be an array or must respond to each, reject and select" unless ::Array === specifications || (specifications.respond_to?(:each) && specifications.respond_to?(:reject) && specifications.respond_to?(:select))

	constants		=	CLI_helpers_::Constants
	specifications.each { |a| raise ::TypeError, "each element in specifications array must be one of the types #{constants::VALID_ALIAS_TYPES_STRING}" unless constants::VALID_ALIAS_TYPES.any? { |c| c === a } }

	stream			=	options[:stream] || $stdout

	version_string	=	CLI_helpers_.generate_version_string_ options

	stream.puts version_string

	exit_code		=	options[:exit_code] || options[:exit]

	exit exit_code if exit_code
end

# ######################################################################## #
# module

end # module CLASP

# ############################## end of file ############################# #


