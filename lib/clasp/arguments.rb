
require File.join(File.dirname(__FILE__), 'arguments')

module Clasp

	class Arguments
 
		private
		class Flag
			def initialize(arg, num_hyphens, label)
				@arg = arg
				@num_hyphens = num_hyphens
				@label = label
				@name = arg
			end # def initialize(arg, num_hyphens, label)
			attr_reader :label
			attr_reader :name
			attr_reader :num_hyphens
			def to_s
				@arg
			end # def to_s
		end # class Flag

		class Option
			def initialize(arg, num_hyphens, label, value)
				@arg = arg
				@num_hyphens = num_hyphens
				@label = label
				@name = ('-' * num_hyphens) + label
				@value = value
			end # def initialize(arg, num_hyphens, label, value)
			attr_reader :label
			attr_reader :name
			attr_reader :num_hyphens
			attr_reader :value
			def to_s
				@arg
			end # def to_s
		end # class Option

		# ######################
		# Construction

		public
		def initialize(argv = ARGV, aliases = nil)

			@flags = []
			@options = []
			@values = []

			forced_value = false

			argv.each do |arg|

				if forced_value
					@values << arg
				elsif '--' == arg
					# all subsequent arguments are values
					forced_value = true
				else
					# do regex test to see if option/flag/value
					if arg =~ /^(-+)([^=]+)/
						hyphens	=	$1
						label	=	$2
						value	=	$'

						if value and not value.empty?
							value = value[1 ... value.size]
							@options << Option::new(arg, hyphens.size, label, value)
						else
							@flags << Flag::new(arg, hyphens.size, label)
						end
					else
						@values << arg
					end
				end
			end

		end # def initialize(argv)

		# ######################
		# Attributes

		public
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
end # module Clasp

