
# ######################################################################## #
# File:         clasp/aliases.rb
#
# Purpose:      Alias classes
#
# Created:      25th October 2014
# Updated:      16th April 2016
#
# Home:         http://github.com/synesissoftware/CLASP.Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2014-2016, Matthew Wilson and Synesis Software
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
# classes

# A class that represents the specification for a command-line flag
class Flag

	# Creates a Flag instance from the given name, aliases, and help
	#
	def initialize(name, aliases, help)

		@name			=	name
		@aliases		=	(aliases || []).select { |a| a and not a.empty? }
		@help			=	help
	end

	# The flag's name string
	attr_reader	:name
	# The flag's aliases array
	attr_reader	:aliases
	# The flag's help string
	attr_reader	:help

	def to_s

		"{#{name}; aliases=#{aliases.join(', ')}; help='#{help}'}"
	end

  private
	@@Help_		=	self.new('--help', [], 'shows this help and terminates')
	@@Version_	=	self.new('--version', [], 'shows version and terminates')
  public
	# An instance of Flag that provides default '--help' information
	def self.Help
		@@Help_
	end # def self.Help
	# An instance of Flag that provides default '--version' information
	def self.Version
		@@Version_
	end # def self.Version
end

# A class that represents the specification for a command-line option
class Option

	# Creates an Option instance from the given name, aliases, help,
	# values_range, and default_value
	#
	def initialize(name, aliases, help, values_range, default_value)

		@name			=	name
		@aliases		=	(aliases || []).select { |a| a and not a.empty? }
		@help			=	help
		@values_range	=	values_range
		@default_value	=	default_value
	end

	# The option's name string
	attr_reader	:name
	# The option's aliases array
	attr_reader	:aliases
	# The option's help string
	attr_reader	:help
	attr_reader	:values_range
	attr_reader	:default_value
end

# ######################################################################## #
# functions

# Generator method that obtains a Flag according to the given parameters
def CLASP.Flag(name, options = {})

	aliases	=	nil
	help	=	nil

	options.each do |k, v|

		case	k
		when	Symbol
			case	k
			when	:alias
				aliases	=	[ v ]
			when	:aliases
				aliases	=	v
			when	:help
				help	=	v
			else
				raise ArgumentError, "invalid option for flag: '#{k}' => '#{v}'"
			end
		else
			raise ArgumentError, "invalid option type for flag: '#{k}' (#{k.class}) => '#{v}'"
		end
	end

	CLASP::Flag.new(name, aliases, help)
end

# Generator method that obtains an Option according to the given parameters
def CLASP.Option(name, options = {})

	aliases			=	nil
	help			=	nil
	values_range	=	nil
	default_value	=	nil

	options.each do |k, v|

		case	k
		when	Symbol
			case	k
			when	:alias
				aliases	=	[ v ]
			when	:aliases
				aliases	=	v
			when	:help
				help	=	v
			when	:values_range, :values
				values_range	=	v
			when	:default_value, :default
				default_value	=	v
			else
				raise ArgumentError, "invalid option for flag: '#{k}' => '#{v}'"
			end
		else
			raise ArgumentError, "invalid option type for flag: '#{k}' (#{k.class}) => '#{v}'"
		end
	end

	CLASP::Option.new(name, aliases, help, values_range, default_value)
end

# ######################################################################## #
# module

end # module CLASP

# ############################## end of file ############################# #

