#! /usr/bin/ruby
#
# executes all other tests

this_file	=	File.expand_path(__FILE__)
this_dir	=	File.expand_path(File.dirname(__FILE__))
$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

puts "executing all test cases in directory #{this_dir}"

Dir["#{this_dir}/*.rb"].each do |file|

#puts "file: [#{file}]"
#puts "FILE: [#{this_file}]"
#puts
#
	next if this_file == file

	require file

end

require 'test/unit'

