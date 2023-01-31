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
  [instructions ip cell memory loop-stack]
  [(if (zero? (nth memory cell))
     (loop [p ip]
       (if (= (nth instructions p) :eloop)
         p
         (recur (inc p))))
     (inc ip)) 
   cell 
   memory 
   loop-stack])

(defn- end-loop
  [ip cell memory loop-stack]
  [(if (zero? (nth memory cell))
     (inc ip)
     (peek loop-stack))
   cell
   memory
   (pop loop-stack)])

(defn run
  "Executes a brainfuck program"
  [instructions]
  (loop [ip 0 cell 0 memory (init-memory 15) loop-stack []]
    ;; (println "memory" memory)
    ;; (println "stack" loop-stack)
    ;; (println "")
    ;; (println "ip" ip)
    ;; (println "cell" cell)
    (when (< ip (count instructions))
      (let [[new-ip new-cell new-memory new-loop-stack] (case (nth instructions ip)
                                                          :inc [(inc ip) cell (assoc memory cell (inc (nth memory cell))) loop-stack]
                                                          :dec [(inc ip) cell (assoc memory cell (dec (nth memory cell))) loop-stack]
                                                          :next [(inc ip) (inc cell) memory loop-stack]
                                                          :prev [(inc ip) (dec cell) memory loop-stack]
                                                          :sloop (start-loop instructions ip cell memory (conj loop-stack ip))
                                                          :eloop (end-loop ip cell memory loop-stack)
                                                          :putc (do
                                                                  (print (char (nth memory cell)))
                                                                  [(inc ip) cell memory loop-stack])
                                                          [(inc ip) cell memory loop-stack])]
        (recur new-ip new-cell new-memory new-loop-stack)))))

(comment ;; Hello World! (works)
  (run (parse "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."))
;; Hello World! (works)
  (run (parse "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.")))