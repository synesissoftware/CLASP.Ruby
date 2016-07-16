#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_ImmutableArray < Test::Unit::TestCase

	ImmutableArray = ::CLASP::Arguments::ImmutableArray

	def test_empty

		ia = ImmutableArray.new []

		assert ia.empty?
		assert_equal 0, ia.size
		assert_equal 0, ia.length
		assert_equal 0, ia.count
		assert_equal 0, ia.count(:abc)
		assert_equal 0, ia.count { |o| !o.nil? }
		assert (ia.find { |o| !o.nil? }).nil?
		assert_equal ImmutableArray.new([]), ia
		assert_not_equal ImmutableArray.new([ :def ]), ia
		assert_not_equal ImmutableArray.new([ :abc, :def ]), ia
		assert ia[0].nil?
		assert ia[1].nil?
		assert_equal ImmutableArray.new([]), ia[0..1]
	end

	def test_one_item

		ia = ImmutableArray.new [ :def ]

		assert !ia.empty?
		assert_equal 1, ia.size
		assert_equal 1, ia.length
		assert_equal 1, ia.count
		assert_equal 0, ia.count(:abc)
		assert_equal 1, ia.count { |o| !o.nil? }
		assert !(ia.find { |o| !o.nil? }).nil?
		assert_not_equal ImmutableArray.new([]), ia
		assert_equal ImmutableArray.new([ :def ]), ia
		assert_not_equal ImmutableArray.new([ :abc, :def ]), ia
		assert_equal :def, ia[0]
		assert ia[1].nil?
		assert_equal ImmutableArray.new([ :def ]), ia[0..1]
	end

	def test_two_items

		ia = ImmutableArray.new [ :abc, :def ]

		assert !ia.empty?
		assert_equal 2, ia.size
		assert_equal 2, ia.length
		assert_equal 2, ia.count
		assert_equal 1, ia.count(:abc)
		assert_equal 2, ia.count { |o| !o.nil? }
		assert !(ia.find { |o| !o.nil? }).nil?
		assert_not_equal ImmutableArray.new([]), ia
		assert_not_equal ImmutableArray.new([ :def ]), ia
		assert_equal ImmutableArray.new([ :abc, :def ]), ia
		assert_equal :abc, ia[0]
		assert_equal :def, ia[1]
		assert_equal ImmutableArray.new([ :abc, :def ]), ia[0..1]
	end
end

# ############################## end of file ############################# #

