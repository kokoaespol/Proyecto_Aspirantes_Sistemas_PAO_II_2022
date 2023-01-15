# frozen_string_literal: true

require 'roda'

require_relative 'interpreter'

EXAMPLES = {
  'hello_world' => <<~HELLO_WORLD,
    '++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.',
  HELLO_WORLD
  'calculate_pi' => <<~CALCULATE_PI
    >  +++++ +++++ +++++ (15 digits)

    [<+>>>>>>>>++++++++++<<<<<<<-]>+++++[<+++++++++>-]+>>>>>>+[<<+++[>>[-<]<[>]<-]>>
    [>+>]<[<]>]>[[->>>>+<<<<]>>>+++>-]<[<<<<]<<<<<<<<+[->>>>>>>>>>>>[<+[->>>>+<<<<]>
    >>>>]<<<<[>>>>>[<<<<+>>>>-]<<<<<-[<<++++++++++>>-]>>>[<<[<+<<+>>>-]<[>+<-]<++<<+
    >>>>>>-]<<[-]<<-<[->>+<-[>>>]>[[<+>-]>+>>]<<<<<]>[-]>+<<<-[>>+<<-]<]<<<<+>>>>>>>
    >[-]>[<<<+>>>-]<<++++++++++<[->>+<-[>>>]>[[<+>-]>+>>]<<<<<]>[-]>+>[<<+<+>>>-]<<<
    <+<+>>[-[-[-[-[-[-[-[-[-<->[-<+<->>]]]]]]]]]]<[+++++[<<<++++++++<++++++++>>>>-]<
    <<<+<->>>>[>+<<<+++++++++<->>>-]<<<<<[>>+<<-]+<[->-<]>[>>.<<<<[+.[-]]>>-]>[>>.<<
    -]>[-]>[-]>>>[>>[<<<<<<<<+>>>>>>>>-]<<-]]>>[-]<<<[-]<<<<<<<<]++++++++++.
  CALCULATE_PI
}.freeze

module Brainfuck
  module Server
    # App implements a web interface to the brainfuck interpreter.
    class App < Roda
      plugin :render
      plugin :flash
      plugin :sessions, secret: ENV['SESSION_SECRET']

      route do |r|
        r.root do
          r.redirect '/posts/'
        end

        r.on 'posts' do
          r.post do
            program = r.params['program']
            next unless program

            flash['output'] = Interpreter.new(program).run
            r.session['example'] = r.params['example']
            r.redirect
          end

          r.get do
            output = flash['output'] || ''
            example = EXAMPLES[r.session['example'] || 'hello_world']
            view 'index', locals: { output:, example: }
          end
        end
      end
    end
  end
end
