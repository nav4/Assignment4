# TODO:
    # Read command line input
    # Print "No equation found" when no valid equations are found
    # Cite in proper MLA format
    # Add more comments, clean up current comments

# Authors: Eric Hebert, <insert names here>
# Run with:
    # pil assignment4.l
    # (assignment4 (1 2 3 4))

# This code was derived from http://picolisp.com/wiki/?99pp93

# Converts a list between infix and prefix notation
(de infix (expression)
   (if (atom expression)
      expression
      (list
         (infix (cadr expression))
         (car expression)
         (infix (caddr expression)))))

# Generate all possible combinations of the expressions
(de expressions (numbers)
   (if (cdr numbers)
      (mapcan
         '((split-index)
            (mapcan
               '((left-list)
                  (mapcan
                     '((right-list)
                        (mapcar
                           '((operator) (list operator left-list right-list))
                           '(+ - * /)))
                     (expressions (tail (- split-index) numbers))))
               (expressions (head split-index numbers))))
         (range 1 (dec (length numbers))))
      (list (car numbers))))

# Find all valid expressions that evaluate to true
(de equations (Lst)
   (use /
      (redef / (left-list right-list)
         (and (n0 right-list) (=0 (% left-list right-list)) (/ left-list right-list)))
      (for (split-index 1  (> (length Lst) split-index)  (inc split-index))
         (for left-list (expressions (head split-index Lst))
            (for right-list (expressions (tail (- split-index) Lst))
               (let? N (eval left-list)
                  (when (= N (eval right-list))
                     (println (infix left-list) '= (infix right-list))
                     (quit))))))))

# Calls the code to generate combinations until a valid equation is found
# If no valid equation was found, print "No equation found"
(de assignment4 (lst)
    (unless (equations lst)
        (println 'No 'equation 'found)
        (quit)))
