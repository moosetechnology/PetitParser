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
	#name : #PPJavaIslandParser,
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
PPJavaIslandParser >> arguments [
	^ $( asParser, nil asParser island,  $) asParser trim
]

{ #category : #class }
PPJavaIslandParser >> block [
	^ (${ asParser,
		((block island: water) plus / nil asParser island),
	$} asParser) ==> [:tokens | nil ]
		
]

{ #category : #class }
PPJavaIslandParser >> classBody [
	 ^ 
	(${ asParser,
		(
		((methodDef island: water) ==> [:tokens | tokens second]) plus /
		((nil asParser island: water) ==> [ :tokens | OrderedCollection new ])
		),
	$} asParser) ==> [:tokens | tokens second select: [:e | e isNil not ]]
]

{ #category : #class }
PPJavaIslandParser >> classDef [
	^ modifiers trim, 'class' asParser, classId trim ==> [:tokens | tokens third ]
]

{ #category : #class }
PPJavaIslandParser >> classId [
	^ (#uppercase asParser, (#letter asParser / #digit asParser) star) flatten 
]

{ #category : #'comments and strings' }
PPJavaIslandParser >> comment [
	| end |
	end := '*/' asParser.
	^ ('/*' asParser, (#any asParser starLazy: end), end)
]

{ #category : #class }
PPJavaIslandParser >> javaClass [
	^ classDef, ((classBody island:water) ==> [:tokens | tokens second ])
]

{ #category : #class }
PPJavaIslandParser >> javaClassIsland [
	^ (javaClass island: water) ==> [:tokens | tokens second]
]

{ #category : #method }
PPJavaIslandParser >> methodBody [ 
	^ semicolon / block
]

{ #category : #method }
PPJavaIslandParser >> methodDef [
	^ methodModifiers, (type island: water), (methodName island:water), (arguments island:water), methodBody ==> [:tokens | tokens third second ]
]

{ #category : #class }
PPJavaIslandParser >> methodModifiers [
	^( ('public' asParser / 'private' asParser / 'protected' asParser) optional, 
	  'static' asParser trim optional, 
	  'final' asParser trim optional,
	  'abstract' asParser trim optional,
	  'synchronized' asParser trim optional,	
	  'native' asParser trim optional) ==> [ :tokens | nil ]
]

{ #category : #method }
PPJavaIslandParser >> methodName [
	^ (#letter asParser, (#letter asParser / #digit asParser) star) flatten 
]

{ #category : #class }
PPJavaIslandParser >> modifiers [
	^ ('public' asParser / 'private' asParser), 'final' asParser trim optional, 'abstract' asParser trim optional
]

{ #category : #method }
PPJavaIslandParser >> semicolon [
	^ ';' asParser
]

{ #category : #'comments and strings' }
PPJavaIslandParser >> singleLineComment [
	| end |
	end := #newline asParser.
	^ ('//' asParser, (#any asParser starLazy: end), end)
]

{ #category : #'as yet unclassified' }
PPJavaIslandParser >> start [
	^ javaClassIsland
]

{ #category : #'comments and strings' }
PPJavaIslandParser >> string [
	| end |
	end := $" asParser.
	^ ($" asParser, (#any asParser starLazy: end), end)
		name: 'string';
		yourself.
]

{ #category : #method }
PPJavaIslandParser >> throws [
	^ 'throws' asParser trim, type trim, ($, asParser, type trim) star
]

{ #category : #method }
PPJavaIslandParser >> type [
	^ (#letter asParser, (#letter asParser / #digit asParser) star) flatten 
]

{ #category : #context }
PPJavaIslandParser >> updateContext: aPPContext [
	super updateContext: aPPContext.
"	aPPContext globalAt: #waterObjects put: (OrderedCollection 
			with: self comment 
			with: self singleLineComment
			with: self string
			with: self block)."
]

{ #category : #method }
PPJavaIslandParser >> water [
	"
		This will allow to skip over
			- Strings, 
			- Comments 
			- and blocks 
		when parsing water. This way, comments and strings cannot confuse the result.
	"

	^ comment / string / singleLineComment / block / #any asParser
]
