(set-logic QF_AUFLIA)
(set-info :source |

======== Logical encoding of the C program: 

x = x + 1;
a[i] = x + 2; 
y = a[i];

Assignments such as x := x+1 coded by creating variables (e.g. x0 and x1)
which represent the value of x before and after the assignment.

An array is logically modeled as a function, so the assignment to
an array is encoded by creating array-type variables representing the array
before and after the assignment.

|)

(declare-const a0 (Array Int Int))
(declare-const a1 (Array Int Int))
(declare-const i0 Int)
(declare-const x0 Int)
(declare-const x1 Int)
(declare-const y1 Int)

(assert (= x1 (+ x0 1)))
(assert (= a1 (store a0 i0 (+ x1 2))))
(assert (= y1 (select a1 i0)))

;; Is it true that after the execution of program y>x holds?

(assert (not (> y1 x1)))

(check-sat)