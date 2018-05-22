#lang sicp
;Exercise 2.70.  The following eight-symbol alphabet with associated relative frequencies was designed to efficiently encode the lyrics of 1950s rock songs. (Note that the ``symbols'' of an ``alphabet'' need not be individual letters.)

;A	2	NA	16
;BOOM	1	SHA	3
;GET	2	YIP	9
;JOB	2	WAH	1
;Use generate-huffman-tree (exercise 2.69) to generate a corresponding Huffman tree, and use encode (exercise 2.68) to encode the following message:

;Get a job

;Sha na na na na na na na na

;Get a job

;Sha na na na na na na na na

;Wah yip yip yip yip yip yip yip yip yip

;Sha boom

;How many bits are required for the encoding? What is the smallest number of bits that would be needed to encode this song if we used a fixed-length code for the eight-symbol alphabet?

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))
(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((eq? x (car set)) true)
        (else (element-of-set? x (cdr set)))))
(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (cond ((leaf? tree) '())
        ((element-of-set? symbol (symbols (left-branch tree))) (cons 0 (encode-symbol symbol (left-branch tree))))
        ((element-of-set? symbol (symbols (right-branch tree))) (cons 1 (encode-symbol symbol (right-branch tree))))
        (else (error "ERR: get-next-branch: symbol was not found in tree!" symbol))))


(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))
(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)    ; symbol
                               (cadr pair))  ; frequency
                    (make-leaf-set (cdr pairs))))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge nodes)
  (let ((first-node (car nodes)))
    (cond ((null? nodes) '())
          ((null? (cdr nodes)) first-node)
          (else (let ((second-node (cadr nodes)))
                  (let ((merged-node (make-code-tree first-node second-node)))
                    (let ((tree-without-first-two (cddr nodes)))
                      (let ((new-tree (adjoin-set merged-node tree-without-first-two)))
                        (successive-merge new-tree)))))))))

(define my-tree (generate-huffman-tree '((a 2) (boom 1) (Get 2) (job 2) (na 16) (Sha 3) (yip 9) (Wah 1))))
;(display my-tree)
(define my-message '(Get a job Sha na na na na na na na na Get a job Sha na na na na na na na na Wah yip yip yip yip yip yip yip yip yip Sha boom))
(display (encode my-message my-tree))
(newline)
;(1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 1 0 1 1)
(length (encode my-message my-tree))
;84 bits
(display (decode (encode my-message my-tree) my-tree))
(newline)
;(Get a job Sha na na na na na na na na Get a job Sha na na na na na na na na Wah yip yip yip yip yip yip yip yip yip Sha boom)

(display (length my-message))
(newline)
;36

; 84 bits were needed to decode this message.  If a fixed-length code were used to encode this 8 symbol alphabet, 3 bits would be needed to be needed to represent each symbol.  Because there are 36 symbols in the message, it would take a minimum of 108 bits to represent the message using a fixed-length code.