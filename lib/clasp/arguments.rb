
require File.join(File.dirname(__FILE__), 'arguments')

module Clasp

	class Arguments
 
		private
		class Flag
			def initialize(arg, num_hyphens, name)
				@arg = arg
				@num_hyphens = num_hyphens
				@name = name
			end # def initialize(arg, num_hyphens, name)
			attr_reader :name
			attr_reader :num_hyphens
			def to_s
				@arg
			end # def to_s
		end # class Flag
		class Option
			def initialize(arg, num_hyphens, name, value)
				@arg = arg
				@num_hyphens = num_hyphens
				@name = name
				@value = value
			end # def initialize(arg, num_hyphens, name, value)
			attr_reader :name
			attr_reader :value
			attr_reader :num_hyphens
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
						name	=	$2
						value	=	$'

						if value and not value.empty?
							value = value[1 ... value.size]
							@options << Option::new(arg, hyphens.size, name, value)
						else
							@flags << Flag::new(arg, hyphens.size, name)
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

