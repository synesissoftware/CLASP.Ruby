# ######################################################################### #
# File:         clasp/internal/version.rb
#
# Purpose:      Version for clasp.ruby library
#
# Created:      14th February 2014
# Updated:      13th October 2014
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


module Recls

	# Current version of the clasp.ruby library
	VERSION				=	'0.1.1'

	private
	VERSION_PARTS_		=	VERSION.split(/[.]/).collect { |n| n.to_i } # :nodoc:
	public
	VERSION_MAJOR		=	VERSION_PARTS_[0] # :nodoc:
	VERSION_MINOR		=	VERSION_PARTS_[1] # :nodoc:
	VERSION_REVISION	=	VERSION_PARTS_[2] # :nodoc:

end

# ############################## end of file ############################# #

