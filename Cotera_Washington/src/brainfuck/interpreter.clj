(ns brainfuck.interpreter)

(def operators {\+ :inc
                \- :dec
                \< :prev
                \> :next
                \, :getc
                \. :putc
                \[ :sloop
                \] :eloop})

(defn parse
  "Maps the brainfuck program to the keyword operators"
  [instructions]
  (vec (map operators instructions)))

(defn- init-memory
  "Creates a vector of a given size that represents the memory"
  [size]
  (vec (take size (repeat 0))))


(defn- start-loop
  [instructions ip cell memory]
  [(if (zero? (nth memory cell))
     (loop [p ip]
       (if (= (nth instructions p) :eloop)
         p
         (recur (inc p))))
     (inc ip)) cell memory])


(defn- end-loop
  [instructions ip cell memory]
  [(if (zero? (nth memory cell))
     (inc ip)
     (loop [p ip]
       (if (= (nth instructions p) :sloop)
         p
         (recur (dec p))))) cell memory]
  )

(defn run
  "Executes a brainfuck program"
  [instructions]
  (loop [ip 0 cell 0 memory (init-memory 15)]
    (println "memory" memory)
    (println "")
    (println "ip" ip)
    (println "cell" cell)
    (when (< ip (count instructions))
      (let [[new-ip new-cell new-memory] (case (nth instructions ip)
                                           :inc [(inc ip) cell (assoc memory cell (inc (nth memory cell)))]
                                           :dec [(inc ip) cell (assoc memory cell (dec (nth memory cell)))]
                                           :next [(inc ip) (inc cell) memory]
                                           :prev [(inc ip) (dec cell) memory]
                                           :sloop (start-loop instructions ip cell memory)
                                           :eloop (end-loop instructions ip cell memory)
                                           :putc (do
                                                   (print (char (nth memory cell)))
                                                   [(inc ip) cell memory])
                                           [(inc ip) cell memory])]
        (recur new-ip new-cell new-memory)))))

;; Hello World! (!works)
;; (run (parse "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."))
;; Hello World! (works)
;; (run (parse "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."))