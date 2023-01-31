(ns brainfuck.core
  (:gen-class) 
  (:require [brainfuck.interpreter :refer [parse run]])
  )

(defn -main [& args]
  (println (run (parse (str args)))))