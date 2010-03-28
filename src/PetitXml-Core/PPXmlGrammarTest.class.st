Class {
	#name : #PPXmlGrammarTest,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'PetitXml-Tests'
}

{ #category : #accessing }
PPXmlGrammarTest class >> packageNamesUnderTest [
	^ #('PetitXml')
]

{ #category : #accessing }
PPXmlGrammarTest class >> resources [
	^ Array with: PPXmlGrammarResource
]

{ #category : #utilities }
PPXmlGrammarTest >> assertParseInvariant: aString [
	"Assert that aString can be parsed, serialized and parsed again to the same tree."

	| tree string |
	tree := self parse: aString.
	self
		deny: tree isPetitFailure
		description: tree printString.
	self assertTreeInvariant: tree.
	string := String
		streamContents: [ :out | tree printXmlOn: out ].
	self
		assert: (self parse: string) = tree
		description: 'Parse invariant not satisifed'
]

{ #category : #utilities }
PPXmlGrammarTest >> assertTreeInvariant: anXmlNode [
	"Assert that anXmlNode is properly setup.."

	anXmlNode nodesDo: [ :node |
		| current children |
		self assert: node root = anXmlNode.
		anXmlNode isDocument
			ifTrue: [ self assert: node document = anXmlNode ].
			
		node isDocument
			ifTrue: [ self assert: node parentNode isNil ]
			ifFalse: [ self assert: node parentNode notNil ].
		node childNodes 
			do: [ :child | self assert: child parentNode == node ].

		current := node firstChild.
		children := OrderedCollection withAll: node children.
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
PPXmlGrammarTest >> parse: aString [
	^ self parse: aString rule: #start
]

{ #category : #parsing }
PPXmlGrammarTest >> parse: aString rule: aSymbol [ 
	| production |
	production := self parser.
	aSymbol = #start 
		ifFalse: [ production := production instVarNamed: aSymbol ].
	^ production end parse: aString
]

{ #category : #accessing }
PPXmlGrammarTest >> parser [
	^ self resource parserAt: self parserClass
]

{ #category : #accessing }
PPXmlGrammarTest >> parserClass [
	^ PPXmlParser
]

{ #category : #accessing }
PPXmlGrammarTest >> resource [
	^ PPXmlGrammarResource current
]

{ #category : #testing }
PPXmlGrammarTest >> testParseAllXml [
	self resource allXmlDefinitions 
		do: [ :each | self assertParseInvariant: each ]
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseComment [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- comment --></schema>' 
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseCommentWithXml [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- <foo></foo> --></schema>' 
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseComplicated [
	self assertParseInvariant: '<?xml foo?>
<foo>
	<bar a="fasdfasdf">
		<zork/>
		<zonk/>
	</bar>
	<!-- with comment -->
</foo>' 
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseDoctype [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE freaking <schema> [ <!-- schema --> ]  >
	<schema></schema>'
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseEmptyElement [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema/>' 
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseNamespace [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><xs:schema></xs:schema>' 
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseSimple [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema></schema>' 
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseSimpleAttribute [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema foo="bar"></schema>' 
]

{ #category : #'testing-specific' }
PPXmlGrammarTest >> testParseWithWhitsepaceAfterProlog [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?>
	<schema></schema>
' 
]
