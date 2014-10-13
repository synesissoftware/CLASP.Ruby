
require File.join(File.dirname(__FILE__), 'arguments')

module Clasp

	class Arguments

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
							@options << arg
						else
							@flags << arg
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

