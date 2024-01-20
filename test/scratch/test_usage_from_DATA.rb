#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Arguments = CLASP::Arguments.load(ARGV, DATA)

puts
puts '*' * 40
puts 'usage:'
puts
CLASP.show_usage(Arguments.specifications)
puts '*' * 40

puts 'version:'
puts
CLASP.show_version Arguments.specifications, version: [ 1, 2, 3 ]
puts '*' * 40

__END__
---
clasp:
  arg-specs:
  - flag:
      name: --version
      alias: -v
      help: shows the program version and quits
  - option:
      name: --verbosity
      help: the verbosity
      values:
      - silent
      - quiet
      - succinct
      - chatty
      - verbose
  - alias:
      resolved: --verbosity=succinct
      aliases:
      - --succinct
      - -s
  - alias:
      resolved: --verbosity=verbose
      alias: --verbose

