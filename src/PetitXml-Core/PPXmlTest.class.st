Class {
	#name : #PPXmlTest,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'PetitXml-Tests'
}

{ #category : #testing }
PPXmlTest class >> isAbstract [
	^ self name = #PPXmlTest
]

{ #category : #accessing }
PPXmlTest class >> packageNamesUnderTest [
	^ #('PetitXml')
]

{ #category : #accessing }
PPXmlTest class >> resources [
	^ Array with: PPXmlResource
]

{ #category : #utilities }
PPXmlTest >> assertParseInvariant: aString [
	"Assert that aString can be parsed, serialized and parsed again to the same tree."

	| tree string |
	tree := self parse: aString.
	self
		deny: tree isFailure
		description: tree printString.
	self assertTreeInvariant: tree.
	string := String
		streamContents: [ :out | tree printXmlOn: out ].
	self
		assert: (self parse: string) = tree
		description: 'Parse invariant not satisifed'
]

{ #category : #utilities }
PPXmlTest >> assertTreeInvariant: anXmlNode [
	"Assert that anXmlNode is properly setup.."

	anXmlNode nodesDo: [ :node |
		| current children |
		node isDocument
			ifTrue: [ self assert: node parentNode isNil ]
			ifFalse: [ self assert: node parentNode notNil ].
		node childNodes 
			do: [ :child | self assert: child parentNode == node ].

		current := node firstChild.
		children := OrderedCollection withAll: node childNodes.
		[ current isNil ] whileFalse: [
			self assert: children notEmpty.
			self assert: children removeFirst == current.
			current := current nextSibling ].
		self assert: children isEmpty.
		
		current := node lastChild.
		children := OrderedCollection withAll: node childNodes.
		[ current isNil ] whileFalse: [
			self assert: children notEmpty.
			self assert: children removeLast == current.
			current := current previousSibling ].
		self assert: children isEmpty ]
]

{ #category : #parsing }
PPXmlTest >> parse: aString [
	^ self parse: aString rule: #start
]

{ #category : #parsing }
PPXmlTest >> parse: aString rule: aSymbol [ 
	| production |
	production := self parser.
	aSymbol = #start 
		ifFalse: [ production := production instVarNamed: aSymbol ].
	^ production end
		parse: aString asParserStream
]

{ #category : #accessing }
PPXmlTest >> parser [
	^ self resource parserAt: self parserClass
]

{ #category : #accessing }
PPXmlTest >> parserClass [
	self subclassResponsibility
]

{ #category : #accessing }
PPXmlTest >> resource [
	^ PPXmlResource current
]
