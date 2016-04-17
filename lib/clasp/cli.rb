
# ######################################################################## #
# File:         clasp/cli.rb
#
# Purpose:      Command-line interface
#
# Created:      27th July 2015
# Updated:      18th April 2016
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

module CLASP

# ######################################################################## #
# methods

# Displays usage for the program according to the given aliases and options
#
# options:
#  +:exit+                                 - a program exit code; exit() not called if not specified
#  +:program_name+                         - program name; inferred from +$0+ if not specified
#  +:stream+                               - output stream; +$stdout+ if not specified
#  +:suppress_blank_lines_between_options+ - does exactly what it says on the tin
#  +:values+                               - appends this string to USAGE line if specified
def self.show_usage aliases, options={}

	options	||=	{}

	raise ArgumentError, "aliases may not be nil" if aliases.nil?
	raise TypeError, "aliases must be an array or must respond to each, reject and select" unless ::Array === aliases || (aliases.respond_to?(:each) && aliases.respond_to?(:reject) && aliases.respond_to?(:select))

	aliases.each { |a| raise TypeError, "each element in aliases must be a Flag or an Option" unless a.is_a?(::CLASP::Flag) || a.is_a?(::CLASP::Option) }

	stream			=	options[:stream] || $stdout
	program_name	=	options[:program_name] || File.basename($0)

	# sift the aliases to sort out which are value-option aliases (VOAs)

	voas			=	{}

	aliases.select { |a| a.name =~ /^-+[a-zA-Z0-3_-]+[=:].+/ }.each do |a|

		a.name =~ /^(-+[a-zA-Z0-3_-]+)[=:](.+)$/

		voas[$1]	=	[] unless voas.has_key? $1
		voas[$1]	<<	[ a, $2 ]
	end

	aliases			=	aliases.reject { |a| a.name =~ /^-+[a-zA-Z0-3_-]+[=:].+/ }

	stream.puts "USAGE: #{program_name} [ ... flags and options ... ] #{options[:values]}"
	stream.puts
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

	exit options[:exit] if options[:exit]
end

def self.show_version aliases, options = {}

	options	||=	{}

	raise ArgumentError, "aliases may not be nil" if aliases.nil?
	raise TypeError, "aliases must be an array or must respond to each, reject and select" unless ::Array === aliases || (aliases.respond_to?(:each) && aliases.respond_to?(:reject) && aliases.respond_to?(:select))

	aliases.each { |a| raise TypeError, "each element in aliases must be a Flag or an Option" unless a.is_a?(::CLASP::Flag) || a.is_a?(::CLASP::Option) }

	stream			=	options[:stream] || $stdout
	program_name	=	options[:program_name] || File.basename($0)


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

	stream.puts "#{program_name} #{version}"

	exit options[:exit] if options[:exit]
end

# ######################################################################## #
# module

end # module CLASP

# ############################## end of file ############################# #


