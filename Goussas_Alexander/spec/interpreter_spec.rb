require 'interpreter'

describe Brainfuck::Interpreter do
  describe '#run' do
    context 'when given a program that increments the data ptr 10 times' do
      interpreter = Brainfuck::Interpreter.new('++++++++++')
      interpreter.run

      it 'has 10 in the first cell of the data array' do
        expect(interpreter.data[0]).to eql(10)
      end

      it 'the data ptr is 0' do
        expect(interpreter.data_ptr).to eql(0)
      end

      it 'has an empty loop stack' do
        expect(interpreter.loops.empty?).to be_truthy
      end
    end

    context 'when given a program that moves the data ptr 10 times and increments the middle cell' do
      interpreter = Brainfuck::Interpreter.new('>>>>>+>>>>>')
      interpreter.run

      it 'has 1 in the 5th cell' do
        expect(interpreter.data[5]).to eql(1)
      end

      it 'the value of data_ptr is 10' do
        expect(interpreter.data_ptr).to eql(10)
      end

      it 'cells other than the 5th one have 0' do
        30_000.times do |i|
          next if i == 5

          expect(interpreter.data[i]).to eql(0)
        end
      end
    end

    context 'when given a program with a simple loop' do
      interpreter = Brainfuck::Interpreter.new('+[>><<-]')
      interpreter.run

      it 'finishes with a no loop on the loop stack' do
        expect(interpreter.loops.empty?).to be_truthy
      end

      it 'the data_ptr is at position 0' do
        expect(interpreter.data_ptr).to eql(0)
      end

      it 'the value at the current position is 0' do
        expect(interpreter.data[interpreter.data_ptr]).to eql(0)
      end
    end

    context 'given a program that increments the second cell 10 times' do
      interpreter = Brainfuck::Interpreter.new('++++++++++[->+<]>.')
      interpreter.run

      it 'cell 0 has value 0' do
        expect(interpreter.data[0]).to eql(0)
      end

      it 'cell 1 has value 10' do
        expect(interpreter.data[1]).to eql(10)
      end

      it 'the data ptr is at position 1' do
        expect(interpreter.data_ptr).to eql(1)
      end

      it 'the loop stack is empty' do
        expect(interpreter.loops.empty?).to be_truthy
      end

      it 'the value at cell 1 is the newline character' do
        expect(interpreter.data[1].chr).to eql("\n")
      end
    end

    context 'given the first part of the hello world program' do
      interpreter = Brainfuck::Interpreter.new('++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]')
      interpreter.run

      it 'cell #0 has value 0' do
        expect(interpreter.data[0]).to eql(0)
      end

      it 'cell #1 has value 0' do
        expect(interpreter.data[1]).to eql(0)
      end

      it 'cell #2 has value 72' do
        expect(interpreter.data[2]).to eql(72)
      end

      it 'cell #3 has value 104' do
        expect(interpreter.data[3]).to eql(104)
      end
    end
  end
end
