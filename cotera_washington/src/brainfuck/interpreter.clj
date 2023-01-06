(ns brainfuck.interpreter)


(defn interpreter
  ""
  [program]
  (let [memory (byte-array 30000)
        pointer 0
        input []
        output ""
        pc 0]
    ))