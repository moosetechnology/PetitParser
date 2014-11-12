"
A MiniHaskellGrammar is proof of concept of indentation sensitive haskell rules.

Instance Variables
	do:		<Object>
	expression:		<Object>
	identifier:		<Object>
	if:		<Object>
	ifElsePart:		<Object>
	ifMultiline:		<Object>
	ifPart:		<Object>
	ifSingleline:		<Object>
	ifThenPart:		<Object>
	let:		<Object>
	number:		<Object>
	print:		<Object>
	space:		<Object>
	statement:		<Object>
	statementBlock:		<Object>
	statementFirst:		<Object>

do
	- xxxxx

expression
	- xxxxx

identifier
	- xxxxx

if
	- xxxxx

ifElsePart
	- xxxxx

ifMultiline
	- xxxxx

ifPart
	- xxxxx

ifSingleline
	- xxxxx

ifThenPart
	- xxxxx

let
	- xxxxx

number
	- xxxxx

print
	- xxxxx

space
	- xxxxx

statement
	- xxxxx

statementBlock
	- xxxxx

statementFirst
	- xxxxx

"
Class {
	#name : #MiniHaskellGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'identifier',
		'number',
		'let',
		'expression',
		'do',
		'statement',
		'print',
		'if',
		'statementBlock',
		'ifSingleline',
		'ifMultiline',
		'ifPart',
		'ifElsePart',
		'ifThenPart',
		'space',
		'ifThenPartLevel',
		'expressionLevel',
		'statementLevel'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> do [
	^ 'do' asParser trim, statementBlock
	==> #second
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> expression [
	^ (identifier trimBlanks, $= asParser, number trimBlanks) ==> [ :tokens | #expr ]
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> expressionLevel [
	^ expression push
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> identifier [
	^ #letter asParser plus flatten
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> if [
	^ ifSingleline / ifMultiline
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> ifElsePart [
	^ 'else' asParser, space, statementBlock
	==> #third
]

{ #category : #grammar }
MiniHaskellGrammar >> ifMultiline [
	^ (ifPart trim, ifThenPart trim, (ifElsePart alignedTo: ifThenPartLevel) optional) trim 
		pop: ifThenPartLevel 

]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> ifPart [
	^ 'if' asParser, space, identifier ==> #third
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> ifSingleline [
	^ ifPart trimBlanks, ifThenPart trimBlanks, ifElsePart trimBlanks
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> ifThenPart [
	^ ifThenPartLevel, 'then' asParser, space, statementBlock ==> #fourth

]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> ifThenPartLevel [
	^ PPPushParser new
		ref: ifThenPartLevel;
		yourself
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> let [
	^ ('let' asParser trim, expression plus aligned) trim
	==> #second
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> number [
	^ #digit asParser plus
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> print [
	^ ('print' asParser trimBlanks, number asParser) ==> [ :tokens | #print ]
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> space [
	^ #space asParser star
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> start [
	^ statement trim star 
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> statement [
	^ print / do / let / if
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> statementBlock [
	^ (statementLevel trim, (statement trim alignedTo: statementLevel) plus, statementLevel pop) ==> #second

	"^ statement trim plus alignIndent"
]

{ #category : #'as yet unclassified' }
MiniHaskellGrammar >> statementLevel [
	^ PPPushParser new
		ref: statementLevel;
		yourself
]
