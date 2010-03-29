Class {
	#name : #PPXmlGrammarTest,
	#superclass : #TestCase,
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
PPXmlGrammarTest >> assertCopyInvariant: aNode [
	"Assert that the copy is equivalent to the original."
	
	| copy |
	copy := aNode copy.
	self deny: aNode == copy.
	self assert: aNode = copy.
	self assert: copy = aNode
]

{ #category : #utilities }
PPXmlGrammarTest >> assertEquivalentInvariant: aNode [
	"Assert that each node is equivalent to itself."
	
	aNode nodesDo: [ :node | 
		self assert: node = node.
		self assert: node hash = node hash ]
]

{ #category : #utilities }
PPXmlGrammarTest >> assertInvariants: aDocumentNode [
	"Assert that anXmlNode is properly setup.."
	
	self assertCopyInvariant: aDocumentNode.
	self assertEquivalentInvariant: aDocumentNode.
	self assertRootInvariant: aDocumentNode.
	self assertParentInvariant: aDocumentNode.
	self assertNavigationInvariant: aDocumentNode.
	self assertTypeInvariant: aDocumentNode
]

{ #category : #utilities }
PPXmlGrammarTest >> assertNavigationInvariant: aXmlNode [
	"Asswer that the firstChild, lastChild, previousSibling, nextSibling are properly setup."

	| current children |
	aXmlNode nodesDo: [ :node |

		" forward "
		current := node firstChild.
		children := OrderedCollection withAll: node children.
		[ current isNil ] whileFalse: [
			self assert: children notEmpty.
			self assert: children removeFirst == current.
			current := current nextSibling ].
		self assert: children isEmpty.
		
		" backward "
		current := node lastChild.
		children := OrderedCollection withAll: node childNodes.
		[ current isNil ] whileFalse: [
			self assert: children notEmpty.
			self assert: children removeLast == current.
			current := current previousSibling ].
		self assert: children isEmpty ]
]

{ #category : #utilities }
PPXmlGrammarTest >> assertParentInvariant: anXmlNode [
	"Assert that the children-parent relationship is properly set."
	
	anXmlNode nodesDo: [ :node |
		node children 
			do: [ :child | self assert: child parent == node ].
		node isDocument 
			ifTrue: [ self assert: node parent isNil ].
		node isElement ifTrue: [ 
			node attributes
				do: [ :child | self assert: child parent == node ] ] ]
]

{ #category : #utilities }
PPXmlGrammarTest >> assertParseInvariant: aString [
	"Assert that aString can be parsed, serialized and parsed again to the same tree."

	| tree string |
	tree := self parse: aString.
	self
		deny: tree isPetitFailure
		description: tree printString.
	string := String
		streamContents: [ :out | tree printXmlOn: out ].
	self
		assert: (self parse: string) = tree
		description: 'Parse invariant not satisifed'.
	self assertInvariants: tree
]

{ #category : #utilities }
PPXmlGrammarTest >> assertRootInvariant: aDocumentNode [
	"Assert that anXmlNode is the root of the tree."
	
	aDocumentNode nodesDo: [ :node |
		self assert: node root == aDocumentNode.
		aDocumentNode isDocument
			ifTrue: [ self assert: node document == aDocumentNode ] ]
]

{ #category : #utilities }
PPXmlGrammarTest >> assertTypeInvariant: aNode [
	"Assert that each node is one of the standard types."
	
	| types |
	aNode nodesDo: [ :node |
		types := Set new.
		#(isAttribute isComment isDoctype isDocument isElement isProcessing isText) do: [ :each |
			(node perform: each)
				ifTrue: [ types add: each ] ].
		self assert: types size = 1 ]
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
