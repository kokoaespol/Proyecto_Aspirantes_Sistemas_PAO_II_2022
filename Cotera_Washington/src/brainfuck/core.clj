(ns brainfuck.core
  (:gen-class) 
  (:require [brainfuck.interpreter :refer [parse run]])
  )

(defn -main [& args]
  (let [file-path (first args)
        input (if (and (not (nil? file-path)) (.exists (java.io.File. file-path)))
                (slurp (java.io.File. file-path))
                (str args))]
    (println (run (parse input)))))