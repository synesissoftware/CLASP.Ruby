#! /usr/bin/ruby
#
# executes all other tests

ThisDir = File.expand_path(File.dirname(__FILE__))
$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')


puts "executing all test cases in directory #{ThisDir}"



Dir["#{ThisDir}/*.rb"].each do |file|

	next if __FILE__ == file

	require file

end

require 'test/unit'

