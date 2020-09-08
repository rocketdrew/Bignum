;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname bignum) (read-case-sensitive #t) (teachpacks ((lib "cs17.ss" "installed-teachpacks"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "cs17.ss" "installed-teachpacks")) #t)))
(require "bignum-operators.rkt")


;; Data definition:
;; bignum: num lists that respresent non-negative arabic numerals
;;    in reverse order, where each element of the digit is a natural number
;;    less than 10 (between 0 and 9) and cannot be empty

;; rbignum: the reverse of a bignum (such that the final element in the list
;;          can be 0)

;; a num list is either
;;    empty
;;    (cons a list) where a is a num and list is a num list
;; nothing else is a num list

;; Example data
;; empty
;; (list 1 2 3)
;; (list 0 0 1 5 5)




;; Carry1: bignum -> bignum

;; Input: bignum1, a bignum
;; Output: a bignum where the first element is the sum of 1 and first element
;;         of bignum1

;; Original input: (list 9 8)
;;     Recursive input: (list 8)
;;     Recursive output: (list 9)

;;     Ideation: add one to the second, cons 0 to RO

;; Original output: (list 0 9)

;; Original input: (list 0 2)
;;    Recursive input: (list 2)
;;    Recursive output: (list 2)
;;    Ideation: cons the sum of 1 and the first of the list to the recursive
;;              output

;; Original output: (list 1 2)

;; Original input: (list 9 9 9 2)
;;    Recursive input: (list 9 9 2)
;;    Recursive output: (list 0 0 3)
;;    Ideation: cons 0 onto the recursive output

;; Original output: (list 0 0 0 3)


(define (carry1 bignum1)
  (cond
    [(empty? bignum1) (list 1)]
    [(cons? bignum1)
     (if (= 9 (first bignum1))
            (cons 0 (carry1 (rest bignum1)))
            (cons (digit-add 1 (first bignum1)) (rest bignum1)))]))

;; Test cases for carry1
(check-expect (carry1 (list 9 8)) (list 0 9))
(check-expect (carry1 empty) (list 1))
(check-expect (carry1 (list 0 1)) (list 1 1))
(check-expect (carry1 (list 5)) (list 6))
(check-expect (carry1 (list 0)) (list 1))          


;; bignum+: bignum * bignum -> bignum
;;
;; Input: bignum1 and bignum2, two bignums
;; Output: a bignum, the sum of bignum 1 and bignum 2
;;
;; Original input: (list 1 2 3) (list 0 0 1 5 5)
;;    Recursive input: (list 2 3) (list 0 1 5 5)
;;    Recursive output: (list 2 4 5 5)
;;
;;    Ideation: add first of both list together and cons onto recursive output
;;
;; Original output: (list 1 2 4 5 5)
;;
;; Input: (list 9 8 5) (list 5 2 6 1)
;;    Recursive input: (list 8 5) (list 2 6 1)
;;    Recursive output: (list 0 2 2)
;;
;;    Ideation: add first of both list together
;;              then minus 10 if the sum is larger than 9
;;              and add 1 to the first of RO
;;              then cons the difference of sum of the first of both list
;;              and 10 onto the recursive output
;;
;; Original output: (list 4 1 2 2)

(define (bignum+ bignum1 bignum2)
  (cond
    [(empty? bignum1) bignum2]
    [(empty? bignum2) bignum1]
    [(and (cons? bignum1) (cons? bignum2))
     (if (<= (digit-add (first bignum1) (first bignum2)) 9)
         (cons (digit-add (first bignum1) (first bignum2))
               (bignum+ (rest bignum1) (rest bignum2)))
         (cons (digit-sub (digit-add (first bignum1) (first bignum2)) 10)
               (bignum+ (carry1 (rest bignum1)) (rest bignum2))))]))

;; Test cases for bignum+:
(check-expect (bignum+ (list 1 2 3) (list 0 0 1 5 5))
              (list 1 2 4 5 5))
(check-expect (bignum+ (list 9 8 5) (list 2 6 1))
              (list 1 5 7))
(check-expect (bignum+ (list 9) (list 2))
              (list 1 1))
(check-expect (bignum+ (list 9 8) (list 2 6))
              (list 1 5 1))
(check-expect (bignum+ (list 0) (list 0))
              (list 0))
(check-expect (bignum+ (list 0 1 3) (list 0))
              (list 0 1 3))
(check-expect (bignum+ (list 0) (list 4 6 6))
              (list 4 6 6))
(check-expect (bignum+ (list 3 9 1) (list 8))
              (list 1 0 2))



;; carry-mult: bignum * bignum -> bignum

;; Input: bignum1 and bignum 2, two bignums
;; Output: a bignum, the product of bignum1 and bignum2

;; Original input: (list 8) (list 1 5)
;;    Recursive input: (list 8) (list 5)
;;    Recursive output: (list 0 0 4)
;;
;;    Ideation: add the product of first of bignum1 and first of bignum2
;;              to the recursive output
;;
;; Original output: (list 8 0 4)

;; OI: (list 9) (list 8 9)
;;    RI: (list 9) (list 9)
;;    RO: (list 0 1 8)
;;
;;    Ideation: Multiply bignum1 by the first of bignum2. Take the remainder
;;       of this and 10 and add it to the RO. Take the quotient of the first
;;       product, cons 0 onto it, and add it to the RO.
;;
;; OO: (list 2 8 8)

(define (carry-mult bignum1 bignum2)
  (cond
    [(empty? bignum2) empty]
    [(cons? bignum2)
     (if (< (digit-mult (first bignum1) (first bignum2)) 9)
     (bignum+
      (list (digit-mult (first bignum1) (first bignum2)))
      (cons 0 (carry-mult bignum1 (rest bignum2))))
     (bignum+
      (list (digit-rem (digit-mult (first bignum1) (first bignum2)) 10)
       (digit-quo (digit-mult (first bignum1) (first bignum2)) 10))
      (cons 0 (carry-mult bignum1 (rest bignum2)))))]))
            
;; Test cases for carry-mult:
(check-expect (carry-mult (list 8) (list 1)) (list 8))
(check-expect (carry-mult (list 8) (list 5)) (list 0 4))
(check-expect (carry-mult (list 8) (list 1 5))
              (list 8 0 4))
(check-expect (carry-mult (list 1) (list 4 6 7))
              (list 4 6 7))
(check-expect (carry-mult (list 0) (list 4 6 7))
              (list 0 0 0))


;; dezero: bignum -> bignum

;; Input: a rbignum
;; Output: a new rbignum in the same input order but with all the initial zeros
;;         removed

;; OI: (list 0 0 0)
;;   RI: (list 0 0)
;;   RO: (list 0)

;;   Ideation: removed the first element of the list if it is zero

;; OO: (list 0)

;; OI: (list 0 1 2)
;;   RI: (list 1 2)
;;   RO: (list 1 2)

;;   Ideation: removed the first element of the list if it is zero

;; OO: (list 1 2)


(define (dezero rbignum)
  (cond
    [(empty? (rest rbignum)) rbignum]
    [(cons? (rest rbignum))
     (if (zero? (first rbignum))
         (dezero (rest rbignum))
         rbignum)]))

;;Test case for dezero:
(check-expect (dezero (list 1 2 3)) (list 1 2 3))
(check-expect (dezero (list 0)) (list 0))
(check-expect (dezero (list 0 1 2)) (list 1 2))
(check-expect (dezero (list 0 0 0)) (list 0))



;; sumparprod: bignum * bignum -> bignum

;; Input: bignum1 and bignum2, two bignums
;; Output: a bignum that is the product of bignum 1 and bignum 2
;;    (might have extraneous zeros at the end)

;; Original input: (list 1 2) (list 0 0 1)
;;    Recursive input: (list 2) (list 0 0 1)
;;    Recursive output: (list 0 0 0 2)
;;
;;    Ideation: multiply the first of bignum1 by bignum2 and add this to
;;              the recursive output
;;
;; Original output: (list 0 0 1 2)

;; Original input: (list 0) (list 4 5 6)
;;    Recursive input: empty (list 4 5 6)
;;    Recursive output: empty
;;
;;    Ideation: multiply the first of bignum1 by bignum2 and add this to
;;              the recursive output
;;
;; Original output: (list 0 0 0)

(define (sumparprod bignum1 bignum2)
     (if (empty? (rest bignum1))
          (carry-mult bignum1 bignum2)
          (bignum+
           (carry-mult (list (first bignum1)) bignum2)
           (cons 0 (sumparprod (rest bignum1) bignum2)))))

;; Test cases for sumparprod:
(check-expect (sumparprod (list 1 2) (list 0 0 1)) (list 0 0 1 2))
(check-expect (sumparprod (list 0) (list 4 5 6)) (list 0 0 0))
(check-expect (sumparprod (list 7) (list 0)) (list 0))


;; bignum*: bignum * bignum -> bignum

;; Input: bignum1 and bignum2, two bignums
;; Output: a bignum, the product of bignum1 and bignum2

(define (bignum* bignum1 bignum2)
  (reverse (dezero (reverse (sumparprod bignum1 bignum2)))))

;; Test cases for bignum*:
(check-expect (bignum* (list 1 2) (list 0 0 1)) (list 0 0 1 2))
(check-expect (bignum* (list 0) (list 4 5 6)) (list 0))
(check-expect (bignum* (list 4 5 6) (list 0)) (list 0))
(check-expect (bignum* (list 0) (list 0)) (list 0))
(check-expect (bignum* (list 7 1) (list 8 1)) (list 6 0 3))
(check-expect (bignum* (list 6 7 8) (list 1 3)) (list 6 5 1 7 2))
(check-expect (bignum* (list 5 5 5) (list 1)) (list 5 5 5))
(check-expect (bignum* (list 3 2 1) (list 0)) (list 0))
(check-expect (bignum* (list 1 2 3 4 5 6 7 8 9) (list 1 2 3 4 5 6 7 8 9))
              (list 1 4 0 1 7 9 9 8 7 7 5 0 1 6 4 5 7 9))