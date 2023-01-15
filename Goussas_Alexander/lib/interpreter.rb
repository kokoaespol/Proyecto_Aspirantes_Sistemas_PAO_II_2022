# frozen_string_literal: true

require_relative 'parser'

module Brainfuck
  # The brainfuck interpreter.
  class Interpreter
    attr_reader :data, :data_ptr, :loops, :output

    def initialize(input)
      @instructions = Parser.new(input).parse
      @data = Array.new(30_000, 0)
      @data_ptr = 0
      @output = ''
      @loops = []
    end

    def run
      @instructions.each { |inst| inst.visit(self) }
      @output
    end

    def visit_plus(_)
      @data[@data_ptr] += 1
    end

    def visit_minus(_)
      @data[@data_ptr] -= 1
    end

    def visit_inc_ptr(_)
      @data_ptr += 1
    end

    def visit_dec_ptr(_)
      @data_ptr -= 1
    end

    def visit_read_into_ptr(_); end

    def visit_output_ptr(_)
      @output += @data[@data_ptr].chr
    end

    # If the byte at the data pointer is zero, then instead of moving the
    # instruction pointer forward to the next command, jump it forward to the
    # command after the matching ] command.
    def visit_begin_loop(loop)
      return if @data[@data_ptr].zero?

      @loops.push(loop.instructions)
      loop.instructions.each { |inst| inst.visit(self) }
    end

    # If the byte at the data pointer is nonzero, then instead of moving the
    # instruction pointer forward to the next command, jump it back to the
    # command after the matching [ command.
    def visit_end_loop(_)
      if @data[@data_ptr].zero?
        @loops.pop
      else
        @loops.last.each { |inst| inst.visit(self) }
      end
    end
  end
end
