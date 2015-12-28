# ######################################################################### #
# File:         clasp/aliases.rb
#
# Purpose:      Alias classes
#
# Created:      25th October 2014
# Updated:      18th August 2015
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


# ######################################################################### #
# module

module CLASP

# ######################################################################### #
# classes

class Flag

	def initialize(name, aliases, help)

		@name			=	name
		@aliases		=	(aliases || []).select { |a| a and not a.empty? }
		@help			=	help
	end

	attr_reader	:name
	attr_reader	:aliases
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

class Option

	def initialize(name, aliases, help, values_range, default_value)

		@name			=	name
		@aliases		=	(aliases || []).select { |a| a and not a.empty? }
		@help			=	help
		@values_range	=	values_range
		@default_value	=	default_value
	end

	attr_reader	:name
	attr_reader	:aliases
	attr_reader	:help
	attr_reader	:values_range
	attr_reader	:default_value
end

# ######################################################################### #
# functions

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

# ######################################################################### #
# module

end # module CLASP

# ############################## end of file ############################## #

