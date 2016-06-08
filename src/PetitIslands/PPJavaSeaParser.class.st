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
	#name : #PPJavaSeaParser,
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
		'javaClassSea',
		'methodModifiers',
		'semicolon',
		'comment',
		'singleLineComment',
		'string',
		'water',
		'letters',
		'spaces'
	],
	#category : #'PetitIslands-Examples'
}

{ #category : #method }
PPJavaSeaParser >> arguments [
	^ $( asParser, nil asParser sea,  $) asParser trim
]

{ #category : #class }
PPJavaSeaParser >> block [
	^ (${ asParser,
		((block sea: water) plus / nil asParser sea: water),
	$} asParser) ==> [:tokens | nil ]
		
]

{ #category : #class }
PPJavaSeaParser >> classBody [
	 ^ 
	(${ asParser,
		(
		(
			(((methodDef ==> [:name | { name } ]) 
			  / 
			  (javaClass ==> [:t | self collectMethodNames: t ])
			) sea: water) ==> #second
		) plus /
		((nil asParser sea: water) ==> [ :tokens | OrderedCollection new ])
		),
	$} asParser) ==> [:tokens | tokens second flatten select: [:e | e isNil not ]]
]

{ #category : #class }
PPJavaSeaParser >> classDef [
	^ modifiers trim, 'class' asParser, classId trim ==> #third
]

{ #category : #class }
PPJavaSeaParser >> classId [
	^ (#uppercase asParser, (#letter asParser / #digit asParser / $_ asParser) star) flatten 
]

{ #category : #support }
PPJavaSeaParser >> collectMethodNames: javaClassResult [
	| name methods |
	name := javaClassResult first.
	methods := javaClassResult second.
	
	^ methods collect: [ :m | name, '::', m ]
]

{ #category : #'comments and strings' }
PPJavaSeaParser >> comment [
	| end |
	end := '*/' asParser.
	^ ('/*' asParser, (end negate star), end)
]

{ #category : #class }
PPJavaSeaParser >> javaClass [
	^ classDef, ((classBody sea:water) ==> #second)
]

{ #category : #class }
PPJavaSeaParser >> javaClassSea [
	^ (javaClass sea: water) ==> #second
]

{ #category : #method }
PPJavaSeaParser >> letters [
	^ (#letter asParser plus)
]

{ #category : #method }
PPJavaSeaParser >> methodBody [ 
	^ semicolon / block
]

{ #category : #method }
PPJavaSeaParser >> methodDef [
	^ methodModifiers, ((type sea: water), ((methodName, arguments) sea:water)) wrapped, methodBody ==> [:tokens | tokens second second second first ]
]

{ #category : #class }
PPJavaSeaParser >> methodModifiers [
	^( ('public' asParser / 'private' asParser / 'protected' asParser) optional, 
	  'static' asParser trim optional, 
	  'final' asParser trim optional,
	  'abstract' asParser trim optional,
	  'synchronized' asParser trim optional,	
	  'native' asParser trim optional) ==> [ :tokens | nil ]
]

{ #category : #method }
PPJavaSeaParser >> methodName [
	^ ((#letter asParser / $_ asParser), (#letter asParser / #digit asParser / $_ asParser) star) flatten 
]

{ #category : #class }
PPJavaSeaParser >> modifiers [
	^ ('public' asParser / 'private' asParser) optional, 'final' asParser trim optional, 'abstract' asParser trim optional
]

{ #category : #method }
PPJavaSeaParser >> semicolon [
	^ ';' asParser
]

{ #category : #'comments and strings' }
PPJavaSeaParser >> singleLineComment [
	| end |
	end := #newline asParser.
	^ ('//' asParser, (end negate star), end)
]

{ #category : #method }
PPJavaSeaParser >> spaces [
	^ #space asParser plus
]

{ #category : #accessing }
PPJavaSeaParser >> start [
	^ javaClassSea
]

{ #category : #'comments and strings' }
PPJavaSeaParser >> string [
	| end |
	end := $" asParser.
	^ ($" asParser, (#any asParser starLazy: end), end)
		name: 'string';
		yourself.
]

{ #category : #method }
PPJavaSeaParser >> throws [
	^ 'throws' asParser trim, type trim, ($, asParser, type trim) star
]

{ #category : #method }
PPJavaSeaParser >> type [
	^ (#letter asParser, (#letter asParser / #digit asParser / $_ asParser) star) flatten 
]

{ #category : #method }
PPJavaSeaParser >> water [
	"
		This will allow to skip over
			- Strings, 
			- Comments 
			- and blocks 
		when parsing water. This way, comments and strings cannot confuse the result.
	"

	^ comment / string / singleLineComment / block / letters / spaces / #any asParser
]
