"
I define the scanner and parser for the FL programming language using the parser combinator framework PetitParser.
"
Class {
	#name : #FLFactorialParser,
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
	#category : #'Factorial-Language'
}

{ #category : #token }
FLFactorialParser >> add [
	^ $+ asParser flatten
]

{ #category : #grammar }
FLFactorialParser >> apply [
	^ open , id , expression star , close
]

{ #category : #grammar }
FLFactorialParser >> binary [
	^ open , expression , operation , expression , close
]

{ #category : #token }
FLFactorialParser >> close [
	^ $) asParser flatten
]

{ #category : #token }
FLFactorialParser >> cmp [
	^ '==' asParser flatten
]

{ #category : #grammar }
FLFactorialParser >> condition [
	^ if , expression , then , expression , else , expression
]

{ #category : #token }
FLFactorialParser >> else [
	^ 'else' asParser flatten
]

{ #category : #token }
FLFactorialParser >> equal [
	^ $= asParser flatten
]

{ #category : #grammar }
FLFactorialParser >> expression [
	^ apply / condition / binary / variable / literal
]

{ #category : #grammar }
FLFactorialParser >> function [
	^ id , variable star , equal , expression
]

{ #category : #token }
FLFactorialParser >> id [
	^ #letter asParser plus flatten
]

{ #category : #token }
FLFactorialParser >> if [
	^ 'if' asParser flatten
]

{ #category : #grammar }
FLFactorialParser >> literal [
	^ num
]

{ #category : #token }
FLFactorialParser >> num [
	^ #digit asParser plus flatten
]

{ #category : #token }
FLFactorialParser >> open [
	^ $( asParser flatten
]

{ #category : #grammar }
FLFactorialParser >> operation [
	^ cmp / add / sub
]

{ #category : #accessing }
FLFactorialParser >> start [
	^ function end
]

{ #category : #token }
FLFactorialParser >> sub [
	^ $- asParser flatten
]

{ #category : #token }
FLFactorialParser >> then [
	^ 'then' asParser flatten
]

{ #category : #grammar }
FLFactorialParser >> variable [
	^ id
]
