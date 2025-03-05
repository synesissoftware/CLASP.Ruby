
# ######################################################################## #
# File:     clasp/util/exceptions.rb
#
# Purpose:  Exception classes
#
# Created:  20th April 2019
# Updated:  6th March 2025
#
# Home:     http://github.com/synesissoftware/CLASP.Ruby
#
# Author:   Matthew Wilson
#
# Copyright (c) 2019-2025, Matthew Wilson and Synesis Information Systems
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

module CLASP # :nodoc:

# Exceptions
module Exceptions

  # Root exception for CLASP
  class CLASPException < RuntimeError; end

  # Root exception for value parsing
  class ValueParserException < CLASPException; end

  # No value specified (and no default value) for an option
  class MissingValueException < ValueParserException; end

  # Exception class indicating invalid values (as opposed to types)
  class InvalidValueException < ValueParserException; end

  # The given value could not be recognised as a (properly-formatted) number
  class InvalidNumberException < InvalidValueException; end

  # The given value could not be recognised as a (properly-formatted) integer
  class InvalidIntegerException < InvalidNumberException; end

  # The value was a valid integer but is out of range
  class IntegerOutOfRangeException < InvalidValueException; end
end # module Exceptions
end # module CLASP


# ############################## end of file ############################# #

