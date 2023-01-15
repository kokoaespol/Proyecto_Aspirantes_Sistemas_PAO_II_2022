require_relative 'tokenizer'
require_relative 'ast'

module Brainfuck
  class Parser
    def initialize(input)
      @tokens = Tokenizer.new(input).tokenize
      @pos = 0
    end

    def advance
      @pos += 1
      @tokens[@pos - 1]
    end

    def peek
      @tokens[@pos]
    end

    def parse
      instructions = []

      while @pos < @tokens.length
        result = parse_instruction
        break unless result

        instructions << result
      end

      instructions
    end

    def parse_instruction
      token = advance
      return unless token

      case token.type
      when TokenType::PLUS then Ast::Plus.new(token)
      when TokenType::MINUS then Ast::Minus.new(token)
      when TokenType::LESS_THAN then Ast::DecPtr.new(token)
      when TokenType::GREATER_THAN then Ast::IncPtr.new(token)
      when TokenType::COMMA then Ast::ReadIntoPtr.new(token)
      when TokenType::DOT then Ast::OutputPtr.new(token)
      when TokenType::LBRACE then parse_begin_loop(token)
      end
    end

    def parse_begin_loop(token)
      instructions = []
      instructions << parse_instruction while peek && peek.type != TokenType::RBRACE
      raise 'Incomplete loop!' unless peek && peek.type == TokenType::RBRACE

      instructions << Ast::EndLoop.new(advance)
      Ast::BeginLoop.new(token, instructions)
    end
  end
end
