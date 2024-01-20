
# ######################################################################## #
# File:         clasp/specifications.rb
#
# Purpose:      Argument specification classes
#
# Created:      25th October 2014
# Updated:      20th January 2024
#
# Home:         http://github.com/synesissoftware/CLASP.Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2014-2024, Matthew Wilson and Synesis Software
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




# ######################################################################## #
# module

=begin
=end

module CLASP


# ######################################################################## #
# classes

# @!visibility private
class SpecificationBase # :nodoc: all

    private
    # @!visibility private
    def check_arity_(blk, range, label) # :nodoc:

        raise ArgumentError, "block must be a #{Proc}; #{blk.class} given" unless blk.nil? || Proc === blk

        if blk

            case blk.arity
            when range

                ;
            else

                msg = "wrong arity for #{label}"

                if $DEBUG

                    raise ArgumentError, msg
                else

                    warn msg
                end
            end
        end
    end
    public
end

# A class that represents the specification for a command-line flag
class FlagSpecification < SpecificationBase

    # Creates a FlagSpecification instance from the given name, aliases, and help
    #
    # === Signature
    #
    # * *Parameters*
    #   - +name+ (+String+) The name, or long-form, of the flag
    #   - +aliases+ (+Array+) 0 or more strings specifying short-form or option-value aliases
    #   - +help+ (+String+) The help string, which may be +nil+
    #   - +extras+ An application-defined additional parameter. If +nil+, it is assigned an empty +Hash+
    #
    # * *Block* An optional block that is called when a matching flag argument is found
    #
    # *NOTE:* Users should prefer the +CLASP::Flag()+ method
    def initialize(name, aliases, help, extras = nil, &blk)

        check_arity_(blk, 0..3, "flag")

        @name       =   name
        @aliases    =   (aliases || []).select { |a| a and not a.empty? }
        @help       =   help
        @extras     =   extras || {}
        @action     =   blk
    end

    # The flag's name string
    attr_reader :name
    # The flag's aliases array
    attr_reader :aliases
    # The flag's help string
    attr_reader :help
    # The flag's extras
    attr_reader :extras

    # (Proc) The procedure
    attr_reader :action

    # @!visibility private
    def action=(blk) # :nodoc: all

        check_arity_(blk, 0..3, "flag")

        @action = blk
    end

    # String form of the flag
    def to_s

        "{#{name}; aliases=#{aliases.join(', ')}; help='#{help}'; extras=#{extras}}"
    end

    # @!visibility private
    def eql? rhs # :nodoc:

        case rhs
        when self.class

            return true if equal?(rhs)
        else

            return false
        end

        return false unless name == rhs.name
        return false unless aliases == rhs.aliases
        return false unless help == rhs.help
        return false unless extras == rhs.extras

        return true
    end

    # Compares instance against another FlagSpecification or against a name (String)
    def == rhs

        case rhs
        when self.class

            return self.eql? rhs
        when String

            return name == rhs
        else

            false
        end
    end

  private
    @@Help_     =   self.new('--help', [], 'shows this help and terminates')
    @@Version_  =   self.new('--version', [], 'shows version and terminates')
  public
    # An instance of FlagSpecification that provides default '--help' information
    #
    # If you wish to specify +extras+ or attach a block, you may do so
    def self.Help(extras = nil, &blk)

        h = @@Help_

        if extras || blk

            return self.new(h.name, h.aliases, h.help, extras, &blk)
        end

        h
    end

    # An instance of FlagSpecification that provides default '--version' information
    #
    # If you wish to specify +extras+ or attach a block, you may do so
    def self.Version(extras = nil, &blk)

        h = @@Version_

        if extras || blk

            return self.new(h.name, h.aliases, h.help, extras, &blk)
        end

        h
    end
end

# A class that represents the specification for a command-line option
class OptionSpecification < SpecificationBase

    # Creates an OptionSpecification instance from the given name, aliases, help,
    # values_range, and default_value
    #
    # === Signature
    #
    # * *Parameters*
    #   - +name+ (+String+) The name, or long-form, of the option
    #   - +aliases+ (+Array+) 0 or more strings specifying short-form or option-value aliases
    #   - +help+ (+String+) The help string, which may be +nil+
    #   - +values_range+ (+Array+) 0 or more strings specifying values supported by the option
    #   - +default_value+ (+String+) The default value of the option, which will be used in the case where an option is specified without a value. May be +nil+
    #   - +required+ (boolean) Whether the option is required. May be +nil+
    #   - +required_message+ (::String) Message to be used when reporting that a required option is missing. May be +nil+ in which case a message of the form "<option-name> not specified; use --help for usage". If begins with the nul character ("\0"), then is used in the place of the <option-name> and placed into the rest of the standard form message
    #   - +constraint+ (Hash) Constraint to be applied to the parsed values of options matching this specification. NOTE: only integer constraints are supported in the current version
    #   - +extras+ An application-defined additional parameter. If +nil+, it is assigned an empty +Hash+
    #
    # * *Block* An optional block that is called when a matching option argument is found
    #
    # *NOTE:* Users should prefer the +CLASP::Option()+ method
    def initialize(name, aliases, help, values_range, default_value, required, required_message, constraint, extras = nil, &blk)

        check_arity_(blk, 0..3, "option")

        @name               =   name
        @aliases            =   (aliases || []).select { |a| a and not a.empty? }
        @help               =   help
        @values_range       =   values_range || []
        @default_value      =   default_value
        @required           =   required
        @required_message   =   nil
        @constraint         =   constraint || {}
        @extras             =   extras || {}
        @action             =   blk

        rm_name             =   nil

        if required_message

            if "\0" == required_message[0]

                rm_name = required_message[1..-1]
            end
        else

            rm_name = "'#{name}'"
        end

        if rm_name

            required_message = "#{rm_name} not specified; use --help for usage"
        end

        @required_message = required_message
    end

    # The option's name string
    attr_reader :name
    # The option's aliases array
    attr_reader :aliases
    # The option's help string
    attr_reader :help
    # The range of values supported by the option
    attr_reader :values_range
    # The default value of the option
    attr_reader :default_value
    # Indicates whether the option is required
    def required?; @required; end
    # The message to be used when reporting that a required option is missing
    attr_reader :required_message
    # The value constraint
    attr_reader :constraint
    # The option's extras
    attr_reader :extras

    # (Proc) The procedure
    attr_reader :action

    # @!visibility private
    def action=(blk) # :nodoc: all

        check_arity_(blk, 0..3, "flag")

        @action = blk
    end

    # String form of the option
    def to_s

        "{#{name}; aliases=#{aliases.join(', ')}; values_range=[ #{values_range.join(', ')} ]; default_value='#{default_value}'; help='#{help}'; required?=#{required?}; required_message=#{required_message}; constraint=#{constraint}; extras=#{extras}}"
    end

    # @!visibility private
    def eql? rhs # :nodoc:

        case rhs
        when self.class

            return true if equal?(rhs)
        else

            return false
        end

        return false unless name == rhs.name
        return false unless aliases == rhs.aliases
        return false unless help == rhs.help
        return false unless values_range == rhs.values_range
        return false unless default_value == rhs.default_value
        return false unless required? == rhs.required?
        return false unless required_message == rhs.required_message
        return false unless extras == rhs.extras

        return true
    end

    # Compares instance against another OptionSpecification or against a name (String)
    def == rhs

        case rhs
        when self.class

            return self.eql? rhs
        when String

            return name == rhs
        else

            false
        end
    end
end

# A class that represents an explicit alias for a flag or an option
class AliasSpecification

    def initialize(name, aliases)

        @name       =   name
        @aliases    =   (aliases || []).select { |a| a and not a.empty? }
        @extras     =   nil
        @help       =   nil
    end

    # The alias' name string
    attr_reader :name
    # The alias' aliases array
    attr_reader :aliases
    # The flag's help string
    attr_reader :help
    # The flag's extras
    attr_reader :extras

    # String form of the option
    def to_s

        "{#{name}; aliases=#{aliases.join(', ')}}"
    end
end


# ######################################################################## #
# functions

# Generator method that obtains a CLASP::FlagSpecification according to the given
# parameters
#
# === Signature
#
# * *Parameters:*
#   - +name+ (::String) The flag name, e.g. '--verbose'
#   - +options+ (::Hash) An options hash, containing any of the following options:
#
# * *Options:*
#   - +:alias+ (::String) An alias, e.g. '-v'
#   - +:aliases+ (::Array) An array of aliases, e.g. [ '-v', '-verb' ]. Ignored if +:alias+ is specified
#   - +:extras+ An application-defined object, usually a hash of custom attributes
#   - +:help+ (::String) A help string
#
# * *Block* An optional block that is called when a matching flag argument is found
def CLASP.Flag(name, options = {}, &blk)

    aliases =   nil
    help    =   nil
    extras  =   nil

    options.each do |k, v|

        case    k
        when    Symbol
            case    k
            when    :alias

                aliases = [ v ] if v
            when    :aliases

                aliases = v unless aliases
            when    :help

                help = v
            when    :extras

                extras = v
            else

                raise ArgumentError, "invalid option for flag: '#{k}' => '#{v}'"
            end
        else

            raise ArgumentError, "invalid option type for flag: '#{k}' (#{k.class}) => '#{v}'"
        end
    end

    CLASP::FlagSpecification.new(name, aliases, help, extras, &blk)
end

# Generator method that obtains a CLASP::OptionSpecification according to the given
# parameters
#
# === Signature
#
# * *Parameters:*
#   - +name+ (::String) The flag name, e.g. '--verbose'
#   - +options+ (::Hash) An options hash, containing any of the following options:
#
# * *Options:*
#   - +:alias+ (::String) An alias, e.g. '-v'
#   - +:aliases+ (::Array) An array of aliases, e.g. [ '-v', '-verb' ].  Ignored if +:alias+ is specified
#   - +:default_value+ The default value for the option
#   - +:default+ [DEPRECATED] Alternative to +:default_value+
#   - +:extras+ An application-defined object, usually a hash of custom attributes
#   - +:help+ (::String) A help string
#   - +:required+ (boolean) Whether the option is required. May be +nil+
#   - +:required_message+ (::String) Message to be used when reporting that a required option is missing. May be +nil+ in which case a message of the form "<option-name> not specified; use --help for usage". If begins with the nul character ("\0"), then is used in the place of the <option-name> and placed into the rest of the standard form message
#   - +:extras+ An application-defined additional parameter. If +nil+, it is assigned an empty +Hash+.
#   - +:constraint+ (Hash) Constraint to be applied to the parsed values of options matching this specification. NOTE: only integer constraints are supported in the current version
#   - +:values_range+ (::Array) An array defining the accepted values for the option
#   - +:values+ [DEPRECATED] Alternative to +:values_range+
#
# * *Block* An optional block that is called when a matching option argument is found
def CLASP.Option(name, options = {}, &blk)

    aliases         =   nil
    help            =   nil
    values_range    =   nil
    default_value   =   nil
    required        =   false
    require_message =   nil
    constraint      =   nil
    extras          =   nil

    options.each do |k, v|

        case    k
        when    Symbol
            case    k
            when    :alias

                aliases = [ v ] if v
            when    :aliases

                aliases = v unless aliases
            when    :help

                help = v
            when    :values_range, :values

                values_range = v
            when    :default_value, :default

                default_value = v
            when    :required

                required = v
            when    :required_message

                require_message = v
            when    :extras

                extras = v
            when    :constraint

                constraint = v
            else

                raise ArgumentError, "invalid option for option: '#{k}' => '#{v}'"
            end
        else

            raise ArgumentError, "invalid option type for option: '#{k}' (#{k.class}) => '#{v}'"
        end
    end

    CLASP::OptionSpecification.new(name, aliases, help, values_range, default_value, required, require_message, constraint, extras, &blk)
end

def CLASP.Alias(name, *args)

    options =   args.pop if args[-1].is_a?(::Hash)
    options ||= {}

    if options[:alias]

        aliases = [ options[:alias] ]
    elsif options[:aliases]

        aliases = options[:aliases]
    else

        aliases = args
    end

    CLASP::AliasSpecification.new name, aliases
end


# ######################################################################## #
# backwards-compatible

Alias       =   AliasSpecification
Flag        =   FlagSpecification
FlagAlias   =   FlagSpecification
Option      =   OptionSpecification
OptionAlias =   OptionSpecification


# ######################################################################## #
# module

end # module CLASP


# ############################## end of file ############################# #

