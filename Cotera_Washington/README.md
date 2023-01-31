# Brainfuck Interpreter in Clojure

This is a simple implementation of a Brainfuck interpreter in the Clojure programming language. The program can be executed in two ways:

## 1. Direct String Processing

    You can pass the Brainfuck code as a string directly to the program. For example:

        $ lein run "++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++++++++++.>+++++++++++++++++.-.<<++.>>-----------.+++++++++++.<<.>>------------.---.+++++++++++++.-------------.<<<."

## 2. File Processing

    You can also pass the path to a file containing the Brainfuck code to the program. For example:

        $ lein run path/file.txt


## Prerequisites

    * Leiningen
    * Java 8 or higher

## Running the Program

    1. Clone or download this repository to your local machine.
    2. Open a terminal and navigate to the project directory.
    3. Run the following command to execute the program:

        $ lein run <input>

    Where <input> is either the Brainfuck code string or the path to the file containing the code.

## License

    Copyright © 2022 FIXME

    This program and the accompanying materials are made available under the
    terms of the Eclipse Public License 2.0 which is available at
    http://www.eclipse.org/legal/epl-2.0.

    This Source Code may also be made available under the following Secondary
    Licenses when the conditions for such availability set forth in the Eclipse
    Public License, v. 2.0 are satisfied: GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or (at your
    option) any later version, with the GNU Classpath Exception which is available
    at https://www.gnu.org/software/classpath/license.html.
