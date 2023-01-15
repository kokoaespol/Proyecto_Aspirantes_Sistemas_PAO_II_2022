module Brainfuck
  module Ast
    class AstNode
      attr_reader :token

      def initialize(token)
          @token = token
      end

      def to_s
        "#{self.class}{'#{@token.lexeme}'}"
      end

      def ==(other)
        self.class == other.class && token == other.token
      end
    end

    class Plus < AstNode
      def visit(visitor)
        visitor.visit_plus(self)
      end
    end

    class Minus < AstNode
      def visit(visitor)
        visitor.visit_minus(self)
      end
    end

    class IncPtr < AstNode
      def visit(visitor)
        visitor.visit_inc_ptr(self)
      end
    end

    class DecPtr < AstNode
      def visit(visitor)
        visitor.visit_dec_ptr(self)
      end
    end

    class ReadIntoPtr < AstNode
      def visit(visitor)
        visitor.visit_read_into_ptr(self)
      end
    end

    class OutputPtr < AstNode
      def visit(visitor)
        visitor.visit_output_ptr(self)
      end
    end

    class BeginLoop < AstNode
      attr_reader :instructions

      def initialize(token, instructions)
        super(token)

        @instructions = instructions
      end

      def visit(visitor)
        visitor.visit_begin_loop(self)
      end

      def to_s
        instructions = instructions ? instructions.map(&:to_s).join(', ') : []
        "#{self.class}{'#{@token.lexeme}', instructions=[#{instructions}]}"
      end

      def ==(other)
        return false if self.class != other.class

        token == other.token && instructions == other.instructions
      end
    end

    class EndLoop < AstNode
      def visit(visitor)
        visitor.visit_end_loop(self)
      end
    end
  end
end
