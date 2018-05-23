#lang sicp
;Exercise 2.74.  Insatiable Enterprises, Inc., is a highly decentralized conglomerate company consisting of a large number of independent divisions located all over the world. The company's computer facilities have just been interconnected by means of a clever network-interfacing scheme that makes the entire network appear to any user to be a single computer. Insatiable's president, in her first attempt to exploit the ability of the network to extract administrative information from division files, is dismayed to discover that, although all the division files have been implemented as data structures in Scheme, the particular data structure used varies from division to division. A meeting of division managers is hastily called to search for a strategy to integrate the files that will satisfy headquarters' needs while preserving the existing autonomy of the divisions.

;Show how such a strategy can be implemented with data-directed programming. As an example, suppose that each division's personnel records consist of a single file, which contains a set of records keyed on employees' names. The structure of the set varies from division to division. Furthermore, each employee's record is itself a set (structured differently from division to division) that contains information keyed under identifiers such as address and salary. In particular:

;a.  Implement for headquarters a get-record procedure that retrieves a specified employee's record from a specified personnel file. The procedure should be applicable to any division's file. Explain how the individual divisions' files should be structured. In particular, what type information must be supplied?

;b.  Implement for headquarters a get-salary procedure that returns the salary information from a given employee's record from any division's personnel file. How should the record be structured in order to make this operation work?

;c.  Implement for headquarters a find-employee-record procedure. This should search all the divisions' files for the record of a given employee and return the record. Assume that this procedure takes as arguments an employee's name and a list of all the divisions' files.

;d.  When Insatiable takes over a new company, what changes must be made in order to incorporate the new personnel information into the central system?


;Firstly, the main idea is to tag is to ask each branch to tag their division file with their unique number or identifier (e.g. '101 division, or 'Toronto division).
(attach-tag '101 division-file-101)
;This is assumed to have happened for the remainder of the question.

;a.  The information that must be supplied is the division identifier - each division file must be tagged with a unique id

;Have each branch update the table of operations for get-record, with the op being 'get-record, and the tag-type being their unique division id (e.g. '101)
(define (install-get-record-division-101)
  (put 'get-record '101
       (lambda (division-file employee) (divisions-existing-get-record division-file employee))))
;The HQ get-record procedure can then be:
(define (get-record division-file employee)
  (apply-generic 'get-record (type-tag division-file) division-file employee))

;b The record can be structured in any way, as long as each division provides an appropriate selector.

;Have each branch update the table of operations for get-salary, with the op being 'get-salary, and the tag-type being their unique division id (e.g. '101)
(define (install-get-salary-division-101)
  (put 'get-salary '101
       (lambda (division-file employee)
         (let ((employee-record (divisions-existing-get-record division-file employee)))
                (divisions-existing-get-salary employee-record)))))
;The HQ get-record procedure can then be:
(define (get-salary division-file employee)
  (apply-generic 'get-salary (type-tag division-file) division-file employee))

;c
(define (find-employee-record files-list employee)
  (cond ((null? files-list) '()) ; couldn't find employee
        (else (let ((cur-division-file (car files-list))
                    (remaining-files (cdr files-list)))
                (let ((result (apply-generic 'get-record (type-tag cur-division-file) employee)))
                  (cond ((null? result) (find-employee-record remaining-files employee))
                        (else result)))))))

;d
;The new company must tag their division files with a unique identifier, maybe something like 'new-company-division-xyz.  Additionally, they must install packages that implement the corresponding get-record and get-salary selectors.