# ######################################################################### #
# File:         clasp/arguments.rb
#
# Purpose:      ;
#
# Created:      14th February 2014
# Updated:      13th October 2014
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
# classes

class Arguments

	private
	class Flag
		def initialize(arg, index, given_name, argument_alias, given_hyphens, given_label)
			@arg			=	arg
			@index			=	index
			@given_name		=	given_name
			@argument_alias	=	argument_alias
			@given_hyphens	=	given_hyphens
			@given_label	=	given_label
			@name			=	argument_alias ? argument_alias.name : given_name
		end # def initialize()
		attr_reader :index
		attr_reader :given_name
		attr_reader :argument_alias
		attr_reader :given_hyphens
		attr_reader :given_label
		attr_reader :name
		def to_s
			@name
		end # def to_s
		def <=>(rhs)
			return -1 if rhs.nil?
			return @arg <=> rhs if rhs.instance_of? String
			r = self.given_hyphens - rhs.given_hyphens
			return r if 0 != r
			r = self.given_label <=> rhs.given_label
			return r
		end # def <=>(rhs)
		def ==(rhs)
			return false if rhs.nil?
			return @arg == rhs if rhs.instance_of? String
			return false if self.given_hyphens != rhs.given_hyphens
			return false if self.given_label != rhs.given_label
			return true
		end # def ==(rhs)
	end # class Flag

	class Option
		def initialize(arg, index, given_name, argument_alias, given_hyphens, given_label, value)
			@arg			=	arg
			@index			=	index
			@given_name		=	given_name
			@argument_alias	=	argument_alias
			@given_hyphens	=	given_hyphens
			@given_label	=	given_label
			@value			=	value
			@name			=	argument_alias ? argument_alias.name : given_name
		end # def initialize()
		attr_reader :index
		attr_reader :given_name
		attr_reader :argument_alias
		attr_reader :given_hyphens
		attr_reader :given_label
		attr_reader :name
		attr_reader :value
		def to_s
			return "#{name}=#{value}" if argument_alias
			@arg
		end # def to_s
	end # class Option

	# ######################
	# Construction

	public
	def initialize(argv = ARGV, aliases = nil)

		@aliases	=	aliases

		@flags		=	[]
		@options	=	[]
		@values		=	[]

		forced_value		=	false
		want_option_value	=	false

		argv.each_with_index do |arg, index|

			if not forced_value
				if '--' == arg
					# all subsequent arguments are values
					forced_value = true
					next
				end

				# do regex test to see if option/flag/value
				if arg =~ /^(-+)([^=]+)/
					hyphens			=	$1
					given_label		=	$2
					given_name		=	"#$1#$2"
					value			=	($' and not $'.empty?) ? $'[1 ... $'.size] : nil
					argument_alias	=	nil

					(aliases || []).each do |a|
						if a.name == given_name or a.aliases.include? given_name
							argument_alias = a
							break
						end
					end

					if argument_alias and argument_alias.is_a? Clasp::Option and not value
						want_option_value = true
						@options << Option.new(arg, index, given_name, argument_alias, hyphens.size, given_label, nil)
					elsif value
						@options << Option.new(arg, index, given_name, argument_alias, hyphens.size, given_label, value)
					else
						@flags << Flag.new(arg, index, given_name, argument_alias, hyphens.size, given_label)
					end

					next
				end
			end

			if want_option_value
				option	=	@options[-1]
				option.instance_eval("@value='#{arg}'")
				want_option_value = false
			else
				@values << arg
			end
		end

	end # def initialize(argv)

	# ######################
	# Attributes

	public
	def aliases
		@aliases.dup
	end # def aliases

	def flags
		@flags.dup
	end # def flags

	def options
		@options.dup
	end # def options

	def values
		@values.dup
	end # def values

end # class Arguments

# ######################################################################### #
# module

end # module Clasp

# ############################## end of file ############################# #

