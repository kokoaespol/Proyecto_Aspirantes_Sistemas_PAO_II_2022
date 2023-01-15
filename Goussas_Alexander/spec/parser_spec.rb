require 'parser'
require 'tokenizer'
require 'ast'

describe Brainfuck::Parser do
  describe '#parse' do
    context 'given a valid brainfuck program' do
      it 'produces the right ast' do
        parser = Brainfuck::Parser.new('+++')
        expect(parser.parse).to eq(
          [
            Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+')),
            Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+')),
            Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+'))
          ]
        )
      end
    end

    context 'given a program with a simple loop' do
      it 'produces the right ast' do
        parser = Brainfuck::Parser.new('+[-]')
        expect(parser.parse).to eq(
          [
            Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+')),
            Brainfuck::Ast::BeginLoop.new(
              Brainfuck::Token.new(Brainfuck::TokenType::LBRACE, '['),
              [
                Brainfuck::Ast::Minus.new(Brainfuck::Token.new(Brainfuck::TokenType::MINUS, '-')),
                Brainfuck::Ast::EndLoop.new(Brainfuck::Token.new(Brainfuck::TokenType::RBRACE, ']'))
              ]
            )
          ]
        )
      end
    end

    context 'given a program with a simple loop and increment/decrement operations' do
      it 'produces the right ast' do
        parser = Brainfuck::Parser.new('+[>><<-]')
        expect(parser.parse).to eq(
          [
            Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+')),
            Brainfuck::Ast::BeginLoop.new(
              Brainfuck::Token.new(Brainfuck::TokenType::LBRACE, '['),
              [
                Brainfuck::Ast::IncPtr.new(Brainfuck::Token.new(Brainfuck::TokenType::GREATER_THAN, '>')),
                Brainfuck::Ast::IncPtr.new(Brainfuck::Token.new(Brainfuck::TokenType::GREATER_THAN, '>')),
                Brainfuck::Ast::DecPtr.new(Brainfuck::Token.new(Brainfuck::TokenType::LESS_THAN, '<')),
                Brainfuck::Ast::DecPtr.new(Brainfuck::Token.new(Brainfuck::TokenType::LESS_THAN, '<')),
                Brainfuck::Ast::Minus.new(Brainfuck::Token.new(Brainfuck::TokenType::MINUS, '-')),
                Brainfuck::Ast::EndLoop.new(Brainfuck::Token.new(Brainfuck::TokenType::RBRACE, ']'))
              ]
            )
          ]
        )
      end
    end

    context 'given a program with nested loops' do
      it 'produces the right ast' do
        parser = Brainfuck::Parser.new('+[++[--]-]')
        expect(parser.parse).to eq(
          [
            Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+')),
            Brainfuck::Ast::BeginLoop.new(
              Brainfuck::Token.new(Brainfuck::TokenType::LBRACE, '['),
              [
                Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+')),
                Brainfuck::Ast::Plus.new(Brainfuck::Token.new(Brainfuck::TokenType::PLUS, '+')),
                Brainfuck::Ast::BeginLoop.new(
                  Brainfuck::Token.new(Brainfuck::TokenType::LBRACE, '['),
                  [
                    Brainfuck::Ast::Minus.new(Brainfuck::Token.new(Brainfuck::TokenType::MINUS, '-')),
                    Brainfuck::Ast::Minus.new(Brainfuck::Token.new(Brainfuck::TokenType::MINUS, '-')),
                    Brainfuck::Ast::EndLoop.new(Brainfuck::Token.new(Brainfuck::TokenType::RBRACE, ']'))
                  ]
                ),
                Brainfuck::Ast::Minus.new(Brainfuck::Token.new(Brainfuck::TokenType::MINUS, '-')),
                Brainfuck::Ast::EndLoop.new(Brainfuck::Token.new(Brainfuck::TokenType::RBRACE, ']'))
              ]
            )
          ]
        )
      end
    end
  end
end
