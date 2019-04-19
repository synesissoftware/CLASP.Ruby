
# ######################################################################## #
# File:         clasp/arguments.rb
#
# Purpose:      Definition of the Arguments class, the main class in
#               CLASP.Ruby
#
# Created:      14th February 2014
# Updated:      19th April 2019
#
# Home:         http://github.com/synesissoftware/CLASP.Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2014-2019, Matthew Wilson and Synesis Software
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



require File.join(File.dirname(__FILE__), 'specifications.rb')

require 'yaml'

=begin
=end

module CLASP

# ######################################################################## #
# classes

# The main class for processing command-line arguments
class Arguments

	# Class that represents a parsed flag
	class FlagArgument

		# @!visibility private
		#
		# [PRIVATE] This method is subject to changed between versions and
		# should not be called directly from application code
		def initialize(arg, given_index, given_name, resolved_name, argument_spec, given_hyphens, given_label, extras) # :nodoc:

			@arg					=	arg
			@given_index			=	given_index
			@given_name				=	given_name
			@argument_specification	=	argument_spec
			@given_hyphens			=	given_hyphens
			@given_label			=	given_label
			@name					=	resolved_name || given_name
			@extras					=	extras.nil? ? {} : extras
		end

		# (Integer) The command-line index of the argument
		attr_reader :given_index
		# (String) The given name of the argument as it appeared in the command-line
		attr_reader :given_name
		# (CLASP::FlagSpecification) The specification matching the argument, or +nil+
		attr_reader :argument_specification
		# (Integer) The number of hyphens of the argument as it appeared in the command-line
		attr_reader :given_hyphens
		# (String) The label of the argument as it appeared in the command-line
		attr_reader :given_label
		# (String) The resolved name of the argument
		attr_reader :name
		# (Object, Hash) The extras associated with the argument
		attr_reader :extras

		# [DEPRECATED] Use +argument_specification+
		def argument_alias; @argument_specification; end

		# (String) The string form of the flag, which is the same as +name+
		def to_s

			@name
		end

		def eql?(rhs) # :nodoc:

			return false if rhs.nil?

			# check name and aliases
			return true if @name == rhs
			return argument_specification.aliases.include? rhs if argument_specification
			false
		end

		def ==(rhs) # :nodoc:

			return false if rhs.nil?
			if not rhs.instance_of? String

				rhs = rhs.name
			end
			eql? rhs
		end

		# A hash-code for this instance
		def hash

			@arg.hash
		end
	end

	# Class that represents a parsed option
	class OptionArgument

		# @!visibility private
		#
		# [PRIVATE] This method is subject to changed between versions and
		# should not be called directly from application code
		def initialize(arg, given_index, given_name, resolved_name, argument_spec, given_hyphens, given_label, value, extras) # :nodoc:

			@arg					=	arg
			@given_index			=	given_index
			@given_name				=	given_name
			@argument_specification	=	argument_spec
			@given_hyphens			=	given_hyphens
			@given_label			=	given_label
			@value					=	value
			@name					=	resolved_name || given_name
			@extras					=	extras.nil? ? {} : extras
		end

		# (Integer) The command-line index of the argument
		attr_reader :given_index
		# (String) The given name of the argument as it appeared in the command-line
		attr_reader :given_name
		# (CLASP::OptionSpecification) The specification matching the argument, or +nil+
		attr_reader :argument_specification
		# (Integer) The number of hyphens of the argument as it appeared in the command-line
		attr_reader :given_hyphens
		# (String) The label of the argument as it appeared in the command-line
		attr_reader :given_label
		# (String) The resolved name of the argument
		attr_reader :name
		# (String) The value of the option
		attr_reader :value
		# (Object, Hash) The extras associated with the argument
		attr_reader :extras

		# [DEPRECATED] Use +argument_specification+
		def argument_alias; @argument_specification; end

		def eql?(rhs) # :nodoc:

			return false if rhs.nil?

			# check name and aliases
			return true if @name == rhs
			return argument_specification.aliases.include? rhs if argument_specification
			false
		end

		def ==(rhs) # :nodoc:

			return false if rhs.nil?
			if not rhs.instance_of? String

				rhs = rhs.name
			end
			eql? rhs
		end

		# A hash-code for this instance
		def hash

			@arg.hash
		end

		# (String) The string form of the flag, which is the same as +name+=+value+
		def to_s

			"#{name}=#{value}"
		end
	end

	# ######################
	# Construction

	# Loads an instance of the class, as specified by +source+, according to the given parameters
	#
	# See the documentation for the ::CLASP module for examples
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +argv+ (+Array+) The arguments array. May not be +nil+. Defaults to +ARGV+
	#   - +source+ (+Hash+, +IO+) The arguments specification, either as a Hash or an instance of an IO-implementing type containing a YAML specification
	#   - +options+ An options hash, containing any of the following options
	#
	# * *Options:*
	#   - +mutate_argv:+ (+Boolean+) Determines if the library should mutate +argv+. Defaults to +true+. This is essential when using CLASP in conjunction with <tt>$\<</tt>
	#
	def self.load(argv, source, options = {}) # :yields: An instance of +CLASP::Arguments+

		options ||= {}

		specs = load_specifications(source, options)

		self.new argv, specs, options
	end

	# Loads the specifications as specified by +source+, according to the given parameters
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +source+ (+Hash+, +IO+) The arguments specification, either as a Hash or an instance of an IO-implementing type containing a YAML specification
	#   - +options+ An options hash, containing any of the following options
	def self.load_specifications(source, options = {}) # :yields: An array of specification instances

		options ||= {}

		h = nil

		case source
		when ::IO

			h = YAML.load(source.read)
		when ::Hash

			h = source
		else

			if source.respond_to?(:to_hash)

				h = source.to_hash
			else

				raise TypeError, "#{self}.#{__method__}() 'source' argument must be a #{::Hash}, or an object implementing #{::IO}, or a type implementing to_hash'"
			end
		end

		specs	=	[]

		_clasp	=	h['clasp'] or raise ArgumentError, "missing top-level 'clasp' element in load configuration"
		::Hash === _clasp or raise ArgumentError, "top-level 'clasp' element must be a #{::Hash}"

		_specs	=	(_clasp['arg-specs'] || _clasp['specifications'] || _clasp['aliases']) or raise ArgumentError, "missing element 'clasp/specifications'"
		::Array === _specs or raise ArgumentError, "top-level 'specifications' element must be a #{::Hash}"

		_specs.each do |_spec|

			case _spec
			when ::Hash

				# TODO: make a utility function and shrink all the following

				_spec.each do |_arg_type, _details|

					case _arg_type
					when 'flag', :flag

						_name	=	_details['name']

						unless _name

							warn "flag specification missing required 'name' field"
						else

							_alias		=	_details['alias']
							_aliases	=	_details['aliases']
							_help		=	_details['help'] || _details['description']

							specs << CLASP.Flag(_name, alias: _alias, aliases: _aliases, help: _help)
						end
					when 'option', :option

						_name	=	_details['name']

						unless _name

							warn "option specification missing required 'name' field"
						else

							_alias				=	_details['alias']
							_aliases			=	_details['aliases']
							_default_value		=	_details['default_value'] || _details['default']
							_help				=	_details['help'] || _details['description']
							_required			=	_details['required']
							_required_message	=	_details['required_message']
							_values_range		=	_details['values_range'] || _details['values']

							specs << CLASP.Option(_name, alias: _alias, aliases: _aliases, default_value: _default_value, help: _help, required: _required, required_message: _required_message, values_range: _values_range)
						end
					when 'alias', :alias

						_resolved	=	_details['resolved']

						unless _resolved

							warn "alias specification missing required 'resolved' field"
						else

							_alias				=	_details['alias']
							_aliases			=	_details['aliases']

							unless _alias || _aliases

								warn "alias specification missing required 'alias' or 'aliases' field"
							else

								specs << CLASP.Flag(_resolved, alias: _alias, aliases: _aliases)
							end
						end
					else

						warn "unknown arg-type '#{_arg_type}' specified"
					end
				end
			else

				warn "non-#{::Hash} element in 'clasp/specifications': #{_spec} (of type #{_spec.class})"
			end
		end

		specs
	end

	# Constructs an instance of the class, according to the given parameters
	#
	# See the documentation for the ::CLASP module for examples
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +argv+ (+Array+) The arguments array. May not be +nil+. Defaults to +ARGV+
	#   - +specifications+ (+Array+) The specifications array. Defaults to +nil+. If none supplied, no aliasing will be performed
	#   - +options+ An options hash, containing any of the following options
	#
	# * *Options:*
	#   - +mutate_argv:+ (+Boolean+) Determines if the library should mutate +argv+. Defaults to +true+. This is essential when using CLASP in conjunction with <tt>$\<</tt>
	#
	def initialize(argv = ARGV, specifications = nil, options = {})

		# have to do this name-swap, as 'options' has CLASP-specific
		# meaning
		init_opts, options	=	options.dup, nil

		init_opts[:mutate_argv] = true unless init_opts.has_key? :mutate_argv

		@program_name		=	init_opts[:program_name] || Arguments.derive_program_name_

		@argv				=	argv
		argv				=	argv.dup
		@argv_original_copy	=	argv.dup.freeze

		@specifications		=	specifications
		@aliases			=	@specifications

		specifications		=	nil if specifications and specifications.empty?

		flags, options, values = Arguments.parse_(argv, specifications)

		[ flags, options, values ].each do |ar|

			class << ar

				undef :inspect
				undef :to_s

				def to_s

					s	=	''

					s	+=	'['
					s	+=	self.map { |v| %Q<"#{v}"> }.join(', ')
					s	+=	']'

					s
				end

				def inspect

					s	=	''

					s	+=	"#<#{self.class}:0x#{(object_id << 1).to_s(16)} ["
					s	+=	self.map { |v| v.inspect }.join(', ')
					s	+=	"]>"

					s
				end
			end
		end

		@flags		=	flags.freeze
		@options	=	options.freeze
		@values		=	values.freeze

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
	# @!visibility private
	def self.derive_program_name_ # :nodoc:

		$0
	end

	# @!visibility private
	def self.parse_(argv, specifications) # :nodoc:

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
					argument_spec	=	nil
					resolved_name	=	nil

					(specifications || []).each do |s|

						if s.name == given_name or s.aliases.include? given_name

							argument_spec	=	s
							resolved_name	=	s.name

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
					if not argument_spec and not value and specifications and 1 == hyphens.size

						# Must match all
						flag_aliases = []
						given_label[0 ... given_label.size].each_char do |c|

							new_flag	=	"-#{c.chr}"

							flag_alias	=	nil

							# special case where the flag's actual name is short form and found here
							flag_alias	||=	specifications.detect { |s| s.is_a?(CLASP::FlagSpecification) && s.name == new_flag }

							# if not found as a flag, look in each specifications' aliases
							flag_alias	||=	specifications.detect { |s| s.aliases.include? new_flag }

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
							flags_argv = flag_aliases.map { |s| s.name }

							grp_flags, grp_options, grp_value = Arguments.parse_(flags_argv, specifications)

							grp_flags.map! { |f| FlagArgument.new(arg, index, given_name, f.name, f.argument_specification, hyphens.size, given_label, argument_spec ? argument_spec.extras : nil) }
							grp_options.map! { |o| OptionArgument.new(arg, index, given_name, o.name, o.argument_specification, hyphens.size, given_label, o.value, argument_spec ? argument_spec.extras : nil) }

							flags.push(*grp_flags)
							options.push(*grp_options)
							values.push(*grp_value)

							next
						end
					end

					if argument_spec and argument_spec.is_a? CLASP::OptionSpecification and not value

						want_option_value = true
						options << OptionArgument.new(arg, index, given_name, resolved_name, argument_spec, hyphens.size, given_label, nil, argument_spec ? argument_spec.extras : nil)
					elsif value

						want_option_value = false
						options << OptionArgument.new(arg, index, given_name, resolved_name, argument_spec, hyphens.size, given_label, value, argument_spec ? argument_spec.extras : nil)
					else

						want_option_value = false
						flags << FlagArgument.new(arg, index, given_name, resolved_name, argument_spec, hyphens.size, given_label, argument_spec ? argument_spec.extras : nil)
					end

					next
				end
			end

			if want_option_value and not forced_value

				option	=	options[-1]
				option.instance_eval("@value='#{arg}'")
				want_option_value = false
			else

				arg		=	arg.dup
				arg_ix	=	::Integer === index ? index : index.dup

				arg.define_singleton_method(:given_index) { arg_ix }

				values << arg
			end
		end

		return flags, options, values
	end

	# ######################
	# Attributes

	public
	# (Array) a frozen array of specifications
	attr_reader :specifications

	# [DEPRECATED] Instead refer to +specifications+
	attr_reader :aliases

	# (Array) a frozen array of flags
	attr_reader :flags

	# (Array) a frozen array of options
	attr_reader :options

	# (Array) a frozen array of values
	attr_reader :values

	# (Array) the (possibly mutated) array of arguments instance passed to new
	attr_reader :argv

	# (Array) unchanged copy of the original array of arguments passed to new
	attr_reader :argv_original_copy

	# (String) The program name
	attr_reader :program_name

	# Finds the first unknown flag or option; +nil+ if all used
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +options+ (Hash) options
	#
	# * *Options:*
	#   - +:specifications+ ([CLASP::Specification]) Array of specifications. If not specified, the instance's +specifications+ attribute is used
	#
	# === Return
	# (CLASP::Arguments::OptionArgument) The first unknown option; +nil+ if none found
	def find_first_unknown options = {}

		option	=	{} if options.nil?

		raise ArgumentError, "options must be nil or Hash - #{option.class} given" unless options.is_a? ::Hash

		specifications	=	options[:specifications] || options[:aliases] || @specifications

		raise ArgumentError, "specifications may not be nil" if specifications.nil?

		flags.each do |f|

			return f unless specifications.any? { |al| al.is_a?(::CLASP::FlagSpecification) && al.name == f.name }
		end

		self.options.each do |o|

			return o unless specifications.any? { |al| al.is_a?(::CLASP::OptionSpecification) && al.name == o.name }
		end

		nil
	end

	# Searches for a flag that matches the given id, returning the flag if
	# found; +nil+ otherwise
	#
	# === Signature
	#
	# * *Parameters:*
	#  - +id+ (String, CLASP::FlagArgument) The name of a flag, or the flag itself
	#
	# === Return
	# (CLASP::Arguments::FlagArgument) The first flag matching +id+; +nil+ if none found
	def find_flag(id)

		flags.each do |flag|

			return flag if flag == id
		end

		nil
	end

	# Searches for a option that matches the given id, returning the option
	# if found; +nil+ otherwise
	#
	# === Signature
	#
	# * *Parameter:*
	#  - +id+ (String, CLASP::OptionArgument) The name of a option, or the option itself
	#
	# === Return
	# (CLASP::Arguments::OptionArgument) The first option matching +id+; +nil+ if none found
	def find_option(id)

		options.each do |option|

			return option if option == id
		end

		nil
	end

	# #################################################################### #
	# backwards-compatible

	# @!visibility private
	Flag	=	FlagArgument	# :nodoc:
	# @!visibility private
	Option	=	OptionArgument	# :nodoc:
end # class Arguments

# ######################################################################## #
# module

end # module CLASP

# ############################## end of file ############################# #


