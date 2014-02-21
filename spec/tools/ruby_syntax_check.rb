#!/usr/bin/env ruby

$VERBOSE = true

ARGV.each do |ruby_file|
  RubyVM::InstructionSequence.compile_file(ruby_file)
end
