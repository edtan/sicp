#lang sicp

;Exercise 2.76.  As a large system with generic operations evolves, new types of data objects or new operations may be needed. For each of the three strategies -- generic operations with explicit dispatch, data-directed style, and message-passing-style -- describe the changes that must be made to a system in order to add new types or new operations. Which organization would be most appropriate for a system in which new types must often be added? Which would be most appropriate for a system in which new operations must often be added?

;In order to add new types and operations,
;For generic operations with explicit dispatch, need to
;*  tag all operands that use the new operation with the appropriate type
;*  add a new procedure for each new operation
;*  add a new condition within an operation's procedure to check for the tag type of the operand
;For data-directed style, need to
;*  tag all operands that use the new operation with the appropriate type
;*  add a new procedure for each new operation and type combination
;*  add this procedure to the table of operations
;*  change all calls to the operation to use apply-generic in order to lookup the correct procedure in the table of operations
;For message-passing, need to
;*  Create a new procedure for each new type
;*  Add each new operation in the dispatch procudure for a particular data type

;If new types are added very often, it may be good to use a message-passing style, as we don't need to explicitly tag types.  Also, each type might not necessarily support all operations, so we don't have to worry about "missing" entries in the table of operations as in a data-driven style.
;If new operations are added very often, it seems the data-driven and message passing approaches should both work well.  However, if the new operations being added need to be implemented on all data types, a data-directed style would be good, as it centralizes the code for a particular operation to a single row in the table of operations.