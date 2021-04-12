;; CSC 570 Assignment 2 - Lambda Calculus Translation
;; Gavin Chao

;; A modified version of the CSC 530 class code provided by John Clements
#lang racket
 
(require rackunit)
 
#|LC	 	=	 	num
                |	 	id
                |	 	(/ id => LC)
                |	 	(LC LC)
                |	 	(+ LC LC)
                |	 	(* LC LC)
                |	 	(ifleq0 LC LC LC)
                |	 	(println LC)|#

(define (my-read str)
  (call-with-input-string str read))

;; determines whether a string represents an addition expression
(define (is-multi? str)
  (is-multi?/stx (my-read str)))
 
(define (is-multi?/stx stx)
  (cond [(and (list? stx)
              (= 3 (length stx))
              (equal? (first stx) '*)) #t]
         [else #f])
  )

;; determines whether a string represents a multiplication expression
(define (is-add? str)
  (is-add?/stx (my-read str)))
 
(define (is-add?/stx stx)
  (cond [(and (list? stx)
              (= 3 (length stx))
              (equal? (first stx) '+)) #t]
         [else #f])
  )

;; determines whether a string represents a lambda
(define (is-lam? str)
  (is-lam?/stx (my-read str)))
 
(define (is-lam?/stx stx)
  (cond [(and (list? stx)
              (= 4 (length stx))
              (equal? (first stx) '/)
              (symbol? (second stx))
              (equal? (third stx) '=>)) #t]
        [else #f])
  )

;; determines whether a string represents a ifleq0
(define (is-ifleq0? str)
  (is-ifleq0?/stx (my-read str)))

(define (is-ifleq0?/stx stx)
  (cond [(and (list? stx)
              (= 4 (length stx))
              (equal? (first stx) 'ifleq0)) #t]
        [else #f])
  )

;; determines whether a string represents a println
(define (is-println? str)
  (is-println?/stx (my-read str)))

(define (is-println?/stx stx)
  (cond [(and (list? stx)
              (= 2 (length stx))
              (equal? (first stx) 'println)) #t]
        [else #f])
  )

;; translates a string of lambda calculus into Python code
(define (translate-lc str)
  (~a (translate-lc/stx (my-read str))))

(define (translate-lc/stx stx)  
  (cond [(is-lam?/stx stx)
         (string-append "lambda " (translate-lc/stx (second stx)) ": " (translate-lc/stx (last stx)))]    
        [(is-multi?/stx stx)
         (string-append "(" (translate-lc/stx (second stx)) " * " (translate-lc/stx (third stx)) ")")]
        [(is-add?/stx stx)
         (string-append "(" (translate-lc/stx (second stx)) " + " (translate-lc/stx (third stx)) ")" )]
        [(is-ifleq0?/stx stx)
         (string-append (translate-lc/stx (third stx)) " if " (translate-lc/stx (second stx)) " <= 0 else " (translate-lc/stx (last stx)))]
        [(is-println?/stx stx)
         (string-append "print(" (translate-lc/stx (second stx)) ")")]
        [(number? stx) (number->string stx)]
        [(symbol? stx) (symbol->string stx)]
        [else (error 'ta "bad input: ~v\n"
                     stx)]))

;; example output of translate-lc
(translate-lc "(+ (+ 2 4) (+ 5 6))")
(translate-lc "(* abc 3)")
(translate-lc "(+ (* 2 abc) (* abc 2))")
(translate-lc "(/ x => (+ x 2))")
(translate-lc "(ifleq0 24 3 4)")
(translate-lc "(println helloworld_string)")

;; check if lambda calculus translation output is the expected valid Python code
(check-equal? (translate-lc "(+ (* 2 4) (+ 5 6))") "((2 * 4) + (5 + 6))")
(check-equal? (translate-lc "(* (* 2 a) (+ 5 6))") "((2 * a) * (5 + 6))")
(check-equal? (translate-lc "(/ x => (* (+ x 2) 22))") "lambda x: ((x + 2) * 22)")
(check-equal? (translate-lc "(ifleq0 (+ 2 2) (* 4 2) (* 7 7))") "(4 * 2) if (2 + 2) <= 0 else (7 * 7)")
(check-equal? (translate-lc "(println (ifleq0 (+ 2 2) (* 4 2) (* 7 7)))") "print((4 * 2) if (2 + 2) <= 0 else (7 * 7))")