
# ######################################################################## #
# File:     clasp/util/value_parser.rb
#
# Purpose:  Utility component for typed values
#
# Created:  20th April 2019
# Updated:  6th March 2025
#
# Home:     http://github.com/synesissoftware/CLASP.Ruby
#
# Author:   Matthew Wilson
#
# Copyright (c) 2019-2025, Matthew Wilson and Synesis Software
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



require File.join(File.dirname(__FILE__), 'exceptions')

=begin
=end

module CLASP # :nodoc:
module Util # :nodoc:

# @!visibility private
module ValueParser # :nodoc: all

  module Internal_ # :nodoc: all

    include Exceptions

    def self.is_integer? type

      h = {}

      return true if Integer == type
      return true if :integer == type

      false
    end

    def self.obtain_integer value, constraint, argument_spec

      # If no value is given, then use the default (and don't do any
      # range testing)

      if (value || '').empty?

        def_value = argument_spec.default_value

        if (def_value || '').to_s.empty?

          msg = "no value specified for the option '#{argument_spec.name}', which has no default value either"

          warn msg if $DEBUG

          raise MissingValueException, msg
        end

        begin

          return Integer(def_value)
        rescue ArgumentError => x

          msg = "default value '#{def_value}' specified for option '#{argument_spec.name}' that requires the value to be an integer"

          warn msg if $DEBUG

          raise InvalidIntegerException, msg
        end
      end

      # obtain the integer from the value

      v = nil

      begin

        v = Integer(value)
      rescue ArgumentError => x

        msg = "value '#{value}' specified for option '#{argument_spec.name}' that requires the value to be an integer"

        warn msg if $DEBUG

        raise InvalidIntegerException, msg
      end

      # Is there a value constraint?:
      #
      # - values (obtained from argument_spec#values)
      # - range
      # - minimum & maximum

      values_range = argument_spec.values_range

      unless values_range.empty?

        v_s   = v.to_s

        v_s   = '+' + v_s unless '-' == v_s[0]

        vr_s  = values_range.map { |x| x.to_s }.map { |x| '-' == x[0] ? x : '+' + x }

        unless vr_s.include? v_s

          msg = "given value '#{value}' specified for option '#{argument_spec.name}' does not fall within the required range"

          raise IntegerOutOfRangeException, msg
        end
      else

        case range = constraint[:range]
        when :negative

          if v >= 0

            msg = "given value '#{value}' specified for option '#{argument_spec.name}' must be a negative integer"

            raise IntegerOutOfRangeException, msg
          end
        when :positive

          if v < 1

            msg = "given value '#{value}' specified for option '#{argument_spec.name}' must be a positive integer"

            raise IntegerOutOfRangeException, msg
          end
        when :non_positive

          if v > 0

            msg = "given value '#{value}' specified for option '#{argument_spec.name}' must be a non-positive integer"

            raise IntegerOutOfRangeException, msg
          end
        when :non_negative

          if v < 0

            msg = "given value '#{value}' specified for option '#{argument_spec.name}' must be a non-negative integer"

            raise IntegerOutOfRangeException, msg
          end
        when Range

          unless range.include?

            msg = "given value '#{value}' specified for option '#{argument_spec.name}' does not fall within the required range"

            raise IntegerOutOfRangeException, msg
          end
        else

          ;
        end
      end

      v
    end
  end # module Internal_

  def value_from_Proc(constraint, value, arg, given_index, given_name, argument_spec, extras)

    value
  end

  def value_from_Hash(constraint, value, arg, given_index, given_name, argument_spec, extras)

    # Check if type is specified; if not, String is assumed

    type = constraint[:type]


    if Internal_.is_integer?(type)

      return Internal_.obtain_integer(value, constraint, argument_spec)
    end


    value
  end
end # module ValueParser

end # module util
end # module CLASP


# ############################## end of file ############################# #

