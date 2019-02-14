
# ######################################################################## #
# File:         clasp/util/immutable_array.rb
#
# Purpose:      Definition of the CLASP::Util::ImmutableArray class
#
# Created:      14th February 2014
# Updated:      14th February 2019
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




=begin
=end

module CLASP
module Util

# ######################################################################## #
# classes

# An immutable array
class ImmutableArray

	include Enumerable

	#:nodoc:
	def initialize(a)

		raise ArgumentError, "must supply array" if a.nil?
		raise TypeError, "must supply instance of #{::Array}; #{a.class} given" unless a.is_a? ::Array

		@a = a
	end

	# Calls the block once for each element in the array
	def each

		return @a.each unless block_given?

		@a.each { |i| yield i }
	end

	# Alias for +length+
	def size

		@a.size
	end

	# Indicates whether the immutable array has no elements
	def empty?

		@a.empty?
	end

	# Same semantics as +Enumerable#find+ for the underlying array
	def find ifnone = nil

		return @a.find(ifnone) { |o| yield o } if block_given?

		@a.find ifnone
	end

	# The number of elements in the immutable array
	def length

		@a.length
	end

	# Same semantics as +Array#slice+
	def slice *args

		case args.length
		when 1

			case args[0]
			when ::Integer

				return @a.slice args[0]
			end
		when 2

			;
		else

			;
		end

		self.class.new @a.slice(*args)
	end

	# Same semantics as +Array#[]+
	def [] *args

		slice(*args)
	end

	# Determines whether +rhs+ is each to the receiver
	def == rhs

		return rhs == @a if rhs.is_a? self.class

		@a == rhs
	end
end

# ######################################################################## #
# module

end # module Util
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

