# ######################################################################### #
# File:         clasp/version.rb
#
# Purpose:      Version for CLASP.Ruby library
#
# Created:      16th November 2014
# Updated:      13th August 201$
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


module Clasp

	# Current version of the CLASP.Ruby library
	VERSION				=	'0.5.2'

	private
	VERSION_PARTS_		=	VERSION.split(/[.]/).collect { |n| n.to_i } # :nodoc:
	public
	VERSION_MAJOR		=	VERSION_PARTS_[0] # :nodoc:
	VERSION_MINOR		=	VERSION_PARTS_[1] # :nodoc:
	VERSION_REVISION	=	VERSION_PARTS_[2] # :nodoc:

end

# ############################## end of file ############################# #
