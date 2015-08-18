# ######################################################################### #
# File:         clasp/arguments.rb
#
# Purpose:      ;
#
# Created:      14th February 2014
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

class Arguments

	private
	class Flag
		def initialize(arg, given_index, given_name, resolved_name, argument_alias, given_hyphens, given_label)
			@arg			=	arg
			@given_index	=	given_index
			@given_name		=	given_name
			@argument_alias	=	argument_alias
			@given_hyphens	=	given_hyphens
			@given_label	=	given_label
			@name			=	resolved_name || given_name
		end # def initialize()
		attr_reader :given_index
		attr_reader :given_name
		attr_reader :argument_alias
		attr_reader :given_hyphens
		attr_reader :given_label
		attr_reader :name
		def to_s
			@name
		end # def to_s
		def eql?(rhs)
			return false if rhs.nil?

			# check name and aliases
			return true if @name == rhs
			return argument_alias.aliases.include? rhs if argument_alias
			return false
		end # eql?
		def ==(rhs)
			return false if rhs.nil?
			if not rhs.instance_of? String
				rhs = rhs.name
			end
			eql? rhs
		end # def ==(rhs)
		def hash
			@arg.hash
		end # def hash
	end # class Flag

	class Option
		def initialize(arg, given_index, given_name, resolved_name, argument_alias, given_hyphens, given_label, value)
			@arg			=	arg
			@given_index	=	given_index
			@given_name		=	given_name
			@argument_alias	=	argument_alias
			@given_hyphens	=	given_hyphens
			@given_label	=	given_label
			@value			=	value
			@name			=	resolved_name || given_name
		end # def initialize()
		attr_reader :given_index
		attr_reader :given_name
		attr_reader :argument_alias
		attr_reader :given_hyphens
		attr_reader :given_label
		attr_reader :name
		attr_reader :value
		def eql?(rhs)
			return false if rhs.nil?

			# check name and aliases
			return true if @name == rhs
			return argument_alias.aliases.include? rhs if argument_alias
			return false
		end # def eql?
		def ==(rhs)
			return false if rhs.nil?
			if not rhs.instance_of? String
				rhs = rhs.name
			end
			eql? rhs
		end # def ==
		def hash
			@arg.hash
		end # def hash
		def to_s
			return "#{name}=#{value}" if argument_alias
			@arg
		end # def to_s
	end # class Option

	class ImmutableArray

		include Enumerable

		def initialize(a)
			@a = a
		end

		def each
			@a.each { |i| yield i }
		end

		def size
			@a.size
		end
		def empty?
			@a.empty?
		end
		def [](index)
			@a[index]
		end

		def ==(rhs)
			return rhs == @a if rhs.is_a? self.class
			return @a == rhs
		end
	end

	# ######################
	# Construction

	public
	#
	# @param options
	#
	# @option :mutate_argv [Boolean] Determines whether the argv argument
	#   will be mutated, by removing all its elements and placing in the
	#   parsed +values+. If not specified, +true+ is assumed
	def initialize(argv = ARGV, aliases = nil, options = {})

		# have to do this name-swap, as 'options' has CLASP-specific
		# meaning
		init_opts, options	=	options.dup, nil

		init_opts[:mutate_argv] = true unless init_opts.has_key? :mutate_argv


		@argv				=	argv
		@argv_original_copy	=	ImmutableArray.new(argv.dup)

		@aliases	=	aliases

		aliases		=	nil if aliases and aliases.empty?

		flags, options, values = Arguments.parse(argv, aliases)

		@flags		=	ImmutableArray.new(flags)
		@options	=	ImmutableArray.new(options)
		@values		=	ImmutableArray.new(values)


		# do argv-mutation, if required
		if init_opts[:mutate_argv]
			while not argv.empty?
				argv.shift
			end
			@values.each do |v|
				argv << v
			end
		end
	end

	private
	def self.parse(argv, aliases)

		flags	=	[]
		options	=	[]
		values	=	[]

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
					resolved_name	=	nil

					(aliases || []).each do |a|
						if a.name == given_name or a.aliases.include? given_name
							argument_alias	=	a
							resolved_name	=	a.name

							# need to check whether the alias is a default-option
							# and, if so, expand out its name and value, and replace
							# the name and (if none previously specified) the value
							if resolved_name =~ /^(-+)([^=]+)=/
								resolved_name	=	"#$1#$2"
								value			||=	$'
							end
							break
						end
					end

					# Here we intercept and (potentially) cater to grouped flags
					if not argument_alias and not value and aliases and 1 == hyphens.size
						# Must match all
						flag_aliases = []
						given_label[0 ... given_label.size].each_char do |c|
							new_flag	=	"-#{c.chr}"
							flag_alias	=	aliases.detect { |a| a.aliases.include? new_flag }
							if not flag_alias
								flag_aliases	=	nil
								break
							else
								flag_aliases	<<	flag_alias
							end
						end
						if flag_aliases
							# got them all, so now have to process them all
							# as normal. Note: is this susceptible to
							# infinite recursion

							# convert to argv and invoke
							flags_argv = flag_aliases.map { |a| a.name }

							grp_flags, grp_options, grp_value = Arguments.parse flags_argv, aliases

							grp_flags.map! { |f| Flag.new(arg, index, given_name, f.name, f.argument_alias, hyphens.size, given_label) }

							flags.push(*grp_flags)
							options.push(*grp_options)
							values.push(*grp_value)

							next
						end
					end

					if argument_alias and argument_alias.is_a? CLASP::Option and not value
						want_option_value = true
						options << Option.new(arg, index, given_name, resolved_name, argument_alias, hyphens.size, given_label, nil)
					elsif value
						want_option_value = false
						options << Option.new(arg, index, given_name, resolved_name, argument_alias, hyphens.size, given_label, value)
					else
						want_option_value = false
						flags << Flag.new(arg, index, given_name, resolved_name, argument_alias, hyphens.size, given_label)
					end

					next
				end
			end

			if want_option_value and not forced_value
				option	=	options[-1]
				option.instance_eval("@value='#{arg}'")
				want_option_value = false
			else
				values << arg
			end
		end

		return flags, options, values

	end # def initialize(argv)

	# ######################
	# Attributes

	public
	# an immutable array of aliases
	def aliases
		@aliases
	end # def aliases

	# an immutable array of flags
	def flags
		@flags
	end # def flags

	# an immutable array of options
	def options
		@options
	end # def options

	# an immutable array of values
	def values
		@values
	end # def values

	# the (possibly mutated) array of arguments instance passed to new
	def argv
		@argv
	end # def argv

	# unchanged copy of the original array of arguments passed to new
	def argv_original_copy
		@argv_original_copy
	end # def argv_original_copy

end # class Arguments

# ######################################################################### #
# module

end # module CLASP

# ######################################################################### #
# extensions

class Array


	# Monkey-patch ==() in order to handle comparison with ImmutableArray,
	# but DO NOT do so for eql?

	alias_method :old_equal, :==

	undef :==

	def ==(rhs)

		return rhs == self if rhs.is_a? CLASP::Arguments::ImmutableArray

		old_equal rhs
	end # def ==()

end # class Array

# ############################## end of file ############################## #

