
# ######################################################################## #
# File:         clasp/arguments.rb
#
# Purpose:      Definition of the Arguments class, the main class in
#               CLASP.Ruby
#
# Created:      14th February 2014
# Updated:      11th June 2016
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




=begin
=end

module CLASP

# ######################################################################## #
# classes

# The main class for processing command-line arguments
class Arguments

	#:stopdoc:
	private
	class Flag #:nodoc: all

		#:nodoc:
		def initialize(arg, given_index, given_name, resolved_name, argument_alias, given_hyphens, given_label, extras)

			@arg			=	arg
			@given_index	=	given_index
			@given_name		=	given_name
			@argument_alias	=	argument_alias
			@given_hyphens	=	given_hyphens
			@given_label	=	given_label
			@name			=	resolved_name || given_name
			@extras			=	extras.nil? ? {} : extras
		end

		attr_reader :given_index
		attr_reader :given_name
		attr_reader :argument_alias
		attr_reader :given_hyphens
		attr_reader :given_label
		attr_reader :name
		attr_reader :extras

		#:nodoc:
		def to_s

			@name
		end

		#:nodoc:
		def eql?(rhs)

			return false if rhs.nil?

			# check name and aliases
			return true if @name == rhs
			return argument_alias.aliases.include? rhs if argument_alias
			false
		end

		#:nodoc:
		def ==(rhs)

			return false if rhs.nil?
			if not rhs.instance_of? String

				rhs = rhs.name
			end
			eql? rhs
		end

		#:nodoc:
		def hash

			@arg.hash
		end
	end

	class Option #:nodoc: all

		#:nodoc:
		def initialize(arg, given_index, given_name, resolved_name, argument_alias, given_hyphens, given_label, value, extras)

			@arg			=	arg
			@given_index	=	given_index
			@given_name		=	given_name
			@argument_alias	=	argument_alias
			@given_hyphens	=	given_hyphens
			@given_label	=	given_label
			@value			=	value
			@name			=	resolved_name || given_name
			@extras			=	extras.nil? ? {} : extras
		end

		attr_reader :given_index
		attr_reader :given_name
		attr_reader :argument_alias
		attr_reader :given_hyphens
		attr_reader :given_label
		attr_reader :name
		attr_reader :value
		attr_reader :extras

		#:nodoc:
		def eql?(rhs)

			return false if rhs.nil?

			# check name and aliases
			return true if @name == rhs
			return argument_alias.aliases.include? rhs if argument_alias
			false
		end

		#:nodoc:
		def ==(rhs)

			return false if rhs.nil?
			if not rhs.instance_of? String

				rhs = rhs.name
			end
			eql? rhs
		end

		#:nodoc:
		def hash

			@arg.hash
		end

		#:nodoc:
		def to_s

			"#{name}=#{value}"
		end
	end

	class ImmutableArray #:nodoc: all

		include Enumerable

		#:nodoc:
		def initialize(a)

			@a = a
		end

		#:nodoc:
		def each

			@a.each { |i| yield i }
		end

		#:nodoc:
		def size

			@a.size
		end

		#:nodoc:
		def empty?

			@a.empty?
		end

		#:nodoc:
		def [](index)

			@a[index]
		end

		#:nodoc:
		def ==(rhs)

			return rhs == @a if rhs.is_a? self.class
			@a == rhs
		end
	end

	#:startdoc:

	# ######################
	# Construction

	public
	# Constructs an instance of the class, according to the given parameters
	#
	# See the documentation for the ::CLASP module for examples
	#
	# === Signature
	#
	# * *Parameters*:
	#   - +argv+:: (+Array+) The arguments array. May not be +nil+. Defaults to +ARGV+.
	#   - +aliases+:: (+Array+) The aliases array. Defaults to +nil+. If none supplied, no aliasing will be performed.
	#   - +options+:: An options hash, containing any of the following options.
	#
	# * *Options*:
	#   - +mutate_arg:+:: (+Boolean+) Determines if the library should mutate +argv+. Defaults to +true+. This is essential when using CLASP in conjunction with <tt>$\<</tt>.
	#
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

							grp_flags.map! { |f| Flag.new(arg, index, given_name, f.name, f.argument_alias, hyphens.size, given_label, argument_alias ? argument_alias.extras : nil) }
							grp_options.map! { |o| Option.new(arg, index, given_name, o.name, o.argument_alias, hyphens.size, given_label, o.value, argument_alias ? argument_alias.extras : nil) }

							flags.push(*grp_flags)
							options.push(*grp_options)
							values.push(*grp_value)

							next
						end
					end

					if argument_alias and argument_alias.is_a? CLASP::Option and not value

						want_option_value = true
						options << Option.new(arg, index, given_name, resolved_name, argument_alias, hyphens.size, given_label, nil, argument_alias ? argument_alias.extras : nil)
					elsif value

						want_option_value = false
						options << Option.new(arg, index, given_name, resolved_name, argument_alias, hyphens.size, given_label, value, argument_alias ? argument_alias.extras : nil)
					else

						want_option_value = false
						flags << Flag.new(arg, index, given_name, resolved_name, argument_alias, hyphens.size, given_label, argument_alias ? argument_alias.extras : nil)
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

	end

	# ######################
	# Attributes

	public
	# an immutable array of aliases
	attr_reader :aliases

	# an immutable array of flags
	attr_reader :flags

	# an immutable array of options
	attr_reader :options

	# an immutable array of values
	attr_reader :values

	# the (possibly mutated) array of arguments instance passed to new
	attr_reader :argv

	# unchanged copy of the original array of arguments passed to new
	attr_reader :argv_original_copy
end

# ######################################################################## #
# module

end # module CLASP

# ######################################################################## #
# extensions

#:nodoc:
class Array

	# Monkey-patched Array#== in order to handle comparison with
	# ImmutableArray
	#
	# NOTE: do not do so for +eql?+

	#:nodoc:
	alias_method :old_equal, :==

	undef :==

	#:nodoc:
	def ==(rhs)

		return rhs == self if rhs.is_a? CLASP::Arguments::ImmutableArray

		old_equal rhs
	end
end

# ############################## end of file ############################# #

