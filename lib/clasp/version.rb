# ######################################################################### #
# File:         clasp/version.rb
#
# Purpose:      Version for CLASP.Ruby library
#
# Created:      16th November 2014
# Updated:      30th December 2015
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


# Main module for CLASP library
module CLASP

	# Current version of the CLASP.Ruby library
	VERSION				=	'0.6.6'

	private
	VERSION_PARTS_		=	VERSION.split(/[.]/).collect { |n| n.to_i } # :nodoc:
	public
	# Major version of the CLASP.Ruby library
	VERSION_MAJOR		=	VERSION_PARTS_[0] # :nodoc:
	# Minor version of the CLASP.Ruby library
	VERSION_MINOR		=	VERSION_PARTS_[1] # :nodoc:
	# Revision version of the CLASP.Ruby library
	VERSION_REVISION	=	VERSION_PARTS_[2] # :nodoc:

end # module CLASP

# ############################## end of file ############################# #
