module Brainfuck
  module TokenType
    PLUS = 1
    MINUS = 2
    LESS_THAN = 3
    GREATER_THAN = 4
    COMMA = 5
    DOT = 6
    LBRACE = 7
    RBRACE = 8
  end

  Token = Struct.new(:type, :lexeme)

  class Tokenizer
    def initialize(input)
      @pos = 0
      @input = input
    end

    def advance
      @pos += 1
      @input[@pos - 1]
    end

    def tokenize
      tokens = []
      while (c = advance)
        token = case c
                when '+' then Token.new(TokenType::PLUS, '+')
                when '-' then Token.new(TokenType::MINUS, '-')
                when '>' then Token.new(TokenType::GREATER_THAN, '>')
                when '<' then Token.new(TokenType::LESS_THAN, '<')
                when '.' then Token.new(TokenType::DOT, '.')
                when ',' then Token.new(TokenType::COMMA, ',')
                when '[' then Token.new(TokenType::LBRACE, '[')
                when ']' then Token.new(TokenType::RBRACE, ']')
                end
        tokens << token if token
      end
      tokens
    end
  end
end
