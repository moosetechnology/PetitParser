"
FL -- The factorial language.

This is a toy functional language.
It provides first-order function definitions on integers.
There are built-in operations for equality, addition, substraction.
The language is powerful enough to define the factorial function.

Copyright (c) 2008, Ralf Laemmel and contributors to the SLPS project
All rights reserved.
"
Class {
	#name : #PPFactorialParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'apply',
		'binary',
		'condition',
		'expression',
		'function',
		'literal',
		'operation',
		'variable',
		'add',
		'close',
		'cmp',
		'else',
		'equal',
		'id',
		'if',
		'num',
		'open',
		'sub',
		'then'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #token }
PPFactorialParser >> add [
	^ $+ asParser flatten
]

{ #category : #grammar }
PPFactorialParser >> apply [
	^ open , id , expression star , close
]

{ #category : #grammar }
PPFactorialParser >> binary [
	^ open , expression , operation , expression , close
]

{ #category : #token }
PPFactorialParser >> close [
	^ $) asParser flatten
]

{ #category : #token }
PPFactorialParser >> cmp [
	^ '==' asParser flatten
]

{ #category : #grammar }
PPFactorialParser >> condition [
	^ if , expression , then , expression , else , expression
]

{ #category : #token }
PPFactorialParser >> else [
	^ 'else' asParser flatten
]

{ #category : #token }
PPFactorialParser >> equal [
	^ $= asParser flatten
]

{ #category : #grammar }
PPFactorialParser >> expression [
	^ apply | condition | binary | variable | literal
]

{ #category : #grammar }
PPFactorialParser >> function [
	^ id , variable star , equal , expression
]

{ #category : #token }
PPFactorialParser >> id [
	^ #letter asParser plus flatten
]

{ #category : #token }
PPFactorialParser >> if [
	^ 'if' asParser flatten
]

{ #category : #grammar }
PPFactorialParser >> literal [
	^ num
]

{ #category : #token }
PPFactorialParser >> num [
	^ #digit asParser plus flatten
]

{ #category : #token }
PPFactorialParser >> open [
	^ $( asParser flatten
]

{ #category : #grammar }
PPFactorialParser >> operation [
	^ cmp | add | sub
]

{ #category : #accessing }
PPFactorialParser >> start [
	^ function end
]

{ #category : #token }
PPFactorialParser >> sub [
	^ $- asParser flatten
]

{ #category : #token }
PPFactorialParser >> then [
	^ 'then' asParser flatten
]

{ #category : #grammar }
PPFactorialParser >> variable [
	^ id
]
