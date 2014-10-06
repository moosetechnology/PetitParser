"
A JavaParser is a island parser, that can extract method names from a java file.

Instance Variables
	arguments:		<Object>
	block:		<Object>
	classBody:		<Object>
	classDef:		<Object>
	classId:		<Object>
	javaClass:		<Object>
	javaClassIsland:		<Object>
	methodBody:		<Object>
	methodDef:		<Object>
	methodModifiers:		<Object>
	methodName:		<Object>
	modifiers:		<Object>
	semicolon:		<Object>
	throws:		<Object>
	type:		<Object>

arguments
	- xxxxx

block
	- xxxxx

classBody
	- xxxxx

classDef
	- xxxxx

classId
	- xxxxx

javaClass
	- xxxxx

javaClassIsland
	- xxxxx

methodBody
	- xxxxx

methodDef
	- xxxxx

methodModifiers
	- xxxxx

methodName
	- xxxxx

modifiers
	- xxxxx

semicolon
	- xxxxx

throws
	- xxxxx

type
	- xxxxx

"
Class {
	#name : #JavaParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'javaClass',
		'classDef',
		'classBody',
		'methodDef',
		'arguments',
		'methodBody',
		'methodName',
		'block',
		'modifiers',
		'classId',
		'type',
		'throws',
		'javaClassIsland',
		'methodModifiers',
		'semicolon',
		'comment',
		'singleLineComment',
		'string',
		'water'
	],
	#category : #'PetitIslands-Examples'
}

{ #category : #method }
JavaParser >> arguments [
	^ $( asParser, nil asParser island,  $) asParser trim
]

{ #category : #class }
JavaParser >> block [
	^ (${ asParser,
		((block island: water) plus / nil asParser island),
	$} asParser) ==> [:tokens | nil ]
		
]

{ #category : #class }
JavaParser >> classBody [
	 ^ 
	(${ asParser,
		(
		((methodDef island: water) ==> [:tokens | tokens second]) plus /
		((nil asParser island: water) ==> [ :tokens | OrderedCollection new ])
		),
	$} asParser) ==> [:tokens | tokens second select: [:e | e isNil not ]]
]

{ #category : #class }
JavaParser >> classDef [
	^ modifiers trim, 'class' asParser, classId trim ==> [:tokens | tokens third ]
]

{ #category : #class }
JavaParser >> classId [
	^ (#uppercase asParser, (#letter asParser / #digit asParser) star) flatten 
]

{ #category : #'comments and strings' }
JavaParser >> comment [
	| end |
	end := '*/' asParser.
	^ ('/*' asParser, (#any asParser starLazy: end), end)
]

{ #category : #class }
JavaParser >> javaClass [
	^ classDef, ((classBody island:water) ==> [:tokens | tokens second ])
]

{ #category : #class }
JavaParser >> javaClassIsland [
	^ (javaClass island: water) ==> [:tokens | tokens second]
]

{ #category : #method }
JavaParser >> methodBody [ 
	^ semicolon / block
]

{ #category : #method }
JavaParser >> methodDef [
	^ methodModifiers, (type island: water), (methodName island:water), (arguments island:water), methodBody ==> [:tokens | tokens third second ]
]

{ #category : #class }
JavaParser >> methodModifiers [
	^( ('public' asParser / 'private' asParser / 'protected' asParser) optional, 
	  'static' asParser trim optional, 
	  'final' asParser trim optional,
	  'abstract' asParser trim optional,
	  'synchronized' asParser trim optional,	
	  'native' asParser trim optional) ==> [ :tokens | nil ]
]

{ #category : #method }
JavaParser >> methodName [
	^ (#letter asParser, (#letter asParser / #digit asParser) star) flatten 
]

{ #category : #class }
JavaParser >> modifiers [
	^ ('public' asParser / 'private' asParser), 'final' asParser trim optional, 'abstract' asParser trim optional
]

{ #category : #method }
JavaParser >> semicolon [
	^ ';' asParser
]

{ #category : #'comments and strings' }
JavaParser >> singleLineComment [
	| end |
	end := #newline asParser.
	^ ('//' asParser, (#any asParser starLazy: end), end)
]

{ #category : #'as yet unclassified' }
JavaParser >> start [
	^ javaClassIsland
]

{ #category : #'comments and strings' }
JavaParser >> string [
	| end |
	end := $" asParser.
	^ ($" asParser, (#any asParser starLazy: end), end)
		name: 'string';
		yourself.
]

{ #category : #method }
JavaParser >> throws [
	^ 'throws' asParser trim, type trim, ($, asParser, type trim) star
]

{ #category : #method }
JavaParser >> type [
	^ (#letter asParser, (#letter asParser / #digit asParser) star) flatten 
]

{ #category : #context }
JavaParser >> updateContext: aPPContext [
	super updateContext: aPPContext.
"	aPPContext globalAt: #waterObjects put: (OrderedCollection 
			with: self comment 
			with: self singleLineComment
			with: self string
			with: self block)."
]

{ #category : #method }
JavaParser >> water [
	"
		This will allow to skip over
			- Strings, 
			- Comments 
			- and blocks 
		when parsing water. This way, comments and strings cannot confuse the result.
	"

	^ comment / string / singleLineComment / block / #any asParser
]
