
# ######################################################################## #
# File:         clasp/cli.rb
#
# Purpose:      Command-line interface
#
# Created:      27th July 2015
# Updated:      11th June 2016
#
# Home:         http://github.com/synesissoftware/CLASP.Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2015-2016, Matthew Wilson and Synesis Software
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

# :nodoc:
module CLI_helpers_

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

# :method: show_usage
# Displays usage for the program according to the given aliases and options
#
# options:
#  +:exit+                                 - a program exit code; exit() not called if not specified
#  +:program_name+                         - program name; inferred from +$0+ if not specified
#  +:stream+                               - output stream; +$stdout+ if not specified
#  +:suppress_blank_lines_between_options+ - does exactly what it says on the tin
#  +:values+                               - appends this string to USAGE line if specified
#  +:flags_and_options+                    - inserts a custom string instead of the default string '[ ... flags and options ... ]'
#  +:info_lines+                           - inserts 0+ information lines prior to the usage
def self.show_usage aliases, options={}

	options	||=	{}

	raise ArgumentError, "aliases may not be nil" if aliases.nil?
	raise TypeError, "aliases must be an array or must respond to each, reject and select" unless ::Array === aliases || (aliases.respond_to?(:each) && aliases.respond_to?(:reject) && aliases.respond_to?(:select))

	aliases.each { |a| raise TypeError, "each element in aliases must be a Flag or an Option" unless a.is_a?(::CLASP::Flag) || a.is_a?(::CLASP::Option) }

	alias_dups = {}
	aliases.each { |a| a.aliases.each { |aa| warn "WARNING: alias '#{aa}' is already used for alias '#{a}'" if alias_dups.has_key? aa; alias_dups[aa] = a; } }

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
	info_lines.map! do |line|

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

	# sift the aliases to sort out which are value-option aliases (VOAs)

	voas			=	{}

	aliases.select { |a| a.name =~ /^-+[a-zA-Z0-3_-]+[=:].+/ }.each do |a|

		a.name =~ /^(-+[a-zA-Z0-3_-]+)[=:](.+)$/

		voas[$1]	=	[] unless voas.has_key? $1
		voas[$1]	<<	[ a, $2 ]
	end

	aliases			=	aliases.reject { |a| a.name =~ /^-+[a-zA-Z0-3_-]+[=:].+/ }

	info_lines.each { |info_line| stream.puts info_line } unless info_lines.empty?

	stream.puts "USAGE: #{program_name}#{flags_and_options}#{values}"
	stream.puts

	unless aliases.empty?
		stream.puts "flags/options:"
		stream.puts
		aliases.each do |a|

			case a
			when Flag

				a.aliases.each { |al| stream.puts "\t#{al}" }
				stream.puts "\t#{a.name}"
				stream.puts "\t\t#{a.help}"
			when Option

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
			stream.puts unless options[:suppress_blank_lines_between_options]
		end
	end

	exit options[:exit] if options[:exit]
end

# Displays version for the program according to the given aliases and options
#
# options:
#  +:exit+                  - a program exit code; exit() not called if not specified
#  +:program_name+          - program name; inferred from +$0+ if not specified
#  +:stream+                - output stream; +$stdout+ if not specified
#  +:version+               - an array (of N elements, each of which will be separated by a period '.'), or a string. Must be specified if not +:version_major+
#  +:version_major+         - a number or string. Only considered and must be specified if +:version+ is not
#  +:version_minor+         - a number or string. Only considered if +:version+ is not
#  +:version_revision+      - a number or string. Only considered if +:version+ is not
#  +:version_build+         - a number or string. Only considered if +:version+ is not
#  +:version_prefix+        - optional string to prefix the version number(s)
def self.show_version aliases, options = {}

	options	||=	{}

	raise ArgumentError, "aliases may not be nil" if aliases.nil?
	raise TypeError, "aliases must be an array or must respond to each, reject and select" unless ::Array === aliases || (aliases.respond_to?(:each) && aliases.respond_to?(:reject) && aliases.respond_to?(:select))

	aliases.each { |a| raise TypeError, "each element in aliases must be a Flag or an Option" unless a.is_a?(::CLASP::Flag) || a.is_a?(::CLASP::Option) }

	stream			=	options[:stream] || $stdout

	version_string	=	CLI_helpers_.generate_version_string_ options

	stream.puts version_string

	exit options[:exit] if options[:exit]
end

# ######################################################################## #
# module

end # module CLASP

# ############################## end of file ############################# #


