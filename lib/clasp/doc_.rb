
# ######################################################################## #
# File:         lib/xqsr3/doc_.rb
#
# Purpose:      Documentation of the CLASP.Ruby modules
#
# Created:      11th June 2016
# Updated:      11th June 2016
#
# Home:         http://github.com/synesissoftware/xqsr3
#
# Author:       Matthew Wilson
#
# Copyright (c) 2016, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
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

# Main module for CLASP.Ruby library
#
# === Examples
#
# ==== Simple command-line, no aliases
#
#     argv = %w{ --show-all=true infile -c outfile }
#
#     args = CLASP::Arguments.new(argv)
#
#     puts args.flags.size         # => 1
#     puts args.flags[0]           # => "#<CLASP::Arguments::Flag:0x007fd23aa3aa98 @arg="-c", @given_index=1, @given_name="-c", @argument_alias=nil, @given_hyphens=1, @given_label="c", @name="-c", @extras={}>"
#     puts args.options.size       # => 1
#     puts args.options[0]         # => "#<CLASP::Arguments::Option:0x007fd23aa3aca0 @arg="--show-all=true", @given_index=0, @given_name="--show-all", @argument_alias=nil, @given_hyphens=2, @given_label="show-all", @value="true", @name="--show-all", @extras={}>"
#     puts args.options[0].value   # => "true"
#     puts args.values.size        # => 2
#     puts args.values[0]          # => "infile"
#     puts args.values[1]          # => "outfile"
#
# ==== Use of the special double-slash flag to treat all subsequent arguments as values
#
#     argv = %w{ --show-all=true -- infile outfile -c }
#
#     args = CLASP::Arguments.new(argv)
#
#     puts args.flags.size         # => 0
#     puts args.options.size       # => 1
#     puts args.options[0]         # => "#<CLASP::Arguments::Option:0x007fd23aa3aca0 @arg="--show-all=true", @given_index=0, @given_name="--show-all", @argument_alias=nil, @given_hyphens=2, @given_label="show-all", @value="true", @name="--show-all", @extras={}>"
#     puts args.values.size        # => 3
#     puts args.values[0]          # => "infile"
#     puts args.values[1]          # => "outfile"
#     puts args.values[2]          # => "-c"
#
# ==== Use of flag short forms
#
#     aliases = [
#
#       CLASP.Flag('--verbose', alias: '-v'),
#       CLASP.Flag('--trace-output', aliases: [ '-t', '--trace' ]),
#     ]
#
#     argv = %w{ -trace -v }
#
#     args = CLASP::Arguments.new(argv, aliases)
#
#     puts args.flags.size        # => 2
#     puts args.flags[0].name     # => "--trace-output"
#     puts args.flags[1].name     # => "--verbose"
#     puts args.options.size      # => 0
#     puts args.values.size       # => 0
#
# ==== Use of flag single short forms combined
#
#     aliases = [
#
#       CLASP.Flag('--expand', alias: '-x'),
#       CLASP.Flag('--verbose', alias: '-v'),
#       CLASP.Flag('--trace-output', aliases: [ '-t', '--trace' ]),
#     ]
#
#     argv = %w{ -tvx }
#
#     args = CLASP::Arguments.new(argv, aliases)
#
#     puts args.flags.size        # => 3
#     puts args.options.size      # => 0
#     puts args.values.size       # => 0
#
# ==== Use of option short form
#
#     aliases = [
#
#       CLASP.Option('--show-all', alias: '-a'),
#     ]
#
#     argv = %w{ -c -a true infile outfile }
#
#     args = CLASP::Arguments.new(argv, aliases)
#
#     puts args.flags.size         # => 1
#     puts args.flags[0]           # => "#<CLASP::Arguments::Flag:0x007f8593b0ddd8 @arg="-c", @given_index=0, @given_name="-c", @argument_alias=nil, @given_hyphens=1, @given_label="c", @name="-c", @extras={}>"
#     puts args.options.size       # => 1
#     puts args.options[0]         # => "#<CLASP::Arguments::Option:0x007f8593b0db80 @arg="-a", @given_index=1, @given_name="-a", @argument_alias=#<CLASP::Option:0x007f8593b2ea10 @name="--show-all", @aliases=["-a"], @help=nil, @values_range=[], @default_value=nil, @extras={}>, @given_hyphens=1, @given_label="a", @value="true", @name="--show-all", @extras={}>"
#     puts args.values.size        # => 2
#     puts args.values[0]          # => "infile"
#     puts args.values[1]          # => "outfile"
#
# === Classes of interest
# * ::CLASP::Arguments
# * ::CLASP::Flag
# * ::CLASP::Option
module CLASP

end # module CLASP

# ############################## end of file ############################# #

