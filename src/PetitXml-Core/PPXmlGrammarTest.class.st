Class {
	#name : #PPXmlGrammarTest,
	#superclass : #PPCompositeParserTest,
	#category : #'PetitXml-Tests'
}

{ #category : #accessing }
PPXmlGrammarTest class >> packageNamesUnderTest [
	^ #('PetitXml')
]

{ #category : #accessing }
PPXmlGrammarTest class >> resources [
	^ Array with: PPXmlResource
]

{ #category : #utilities }
PPXmlGrammarTest >> assertAttributeInvariant: aNode [
	"Assert that the attributes can be properly accessed."
	
	aNode nodesDo: [ :node |
		node isElement ifTrue: [
			node attributes do: [ :attr |
				self assert: (node attributeAt: attr name localName) = attr value.
				self assert: (node attributeNodeAt: attr name localName) = attr ].
			node attributes isEmpty ifTrue: [ 
				self assert: (node attributeAt: 'foo') isNil.
				self assert: (node attributeNodeAt: 'foo') isNil ] ] ]
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
	self assertAttributeInvariant: aDocumentNode.
	self assertTypeInvariant: aDocumentNode
]

{ #category : #utilities }
PPXmlGrammarTest >> assertNameInvariant: aXmlName [
	"Asser the name invariants."
	
	self assert: (aXmlName localName notNil and: [ aXmlName localName notEmpty and: [ aXmlName qualifiedName endsWith: aXmlName localName ] ]).
	self assert: (aXmlName namespacePrefix isNil or: [ aXmlName namespacePrefix notEmpty and: [ aXmlName qualifiedName beginsWith: aXmlName namespacePrefix ] ]).
	self assert: (aXmlName uri isNil or: [ aXmlName uri notEmpty ]).
	
	self assert: aXmlName = aXmlName.
	self assert: aXmlName copy = aXmlName.
	self assert: aXmlName = aXmlName copy.
	
	self assert: aXmlName printString isString
	
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
	
	self assert: (aDocumentNode childNodes includes: aDocumentNode rootElement).
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
		self assert: types size = 1.
		(node isElement or: [ node isAttribute ])
			ifTrue: [ self assertNameInvariant: node name ] ]
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
		ifFalse: [ production := production productionAt: aSymbol ].
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
	^ PPXmlResource current
]

{ #category : #'testing-other' }
PPXmlGrammarTest >> testInstantiation [
	self should: [ PPXmlAttribute new ] raise: Error.
	self should: [ PPXmlComment new ] raise: Error.
	self should: [ PPXmlDoctype new ] raise: Error.
	self should: [ PPXmlProcessing new ] raise: Error.
	self should: [ PPXmlText new ] raise: Error.
	self should: [ PPXmlDocument new ] raise: Error.
	self should: [ PPXmlElement new ] raise: Error
]

{ #category : #testing }
PPXmlGrammarTest >> testParseAllXml [
	self resource allXmlDefinitions 
		do: [ :each | self assertParseInvariant: each ]
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseComment [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- comment --></schema>' 
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseCommentWithXml [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- <foo></foo> --></schema>' 
]

{ #category : #'testing-parsing' }
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

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseDoctype [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE freaking <schema> [ <!-- schema --> ]  >
	<schema></schema>'
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseEmptyElement [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema/>' 
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseNamespace [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><xs:schema></xs:schema>' 
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseSimple [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema></schema>' 
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseSimpleAttribute [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema foo="bar"></schema>' 
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseSimpleAttributeWithSingleQuote [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema foo=''bar''></schema>' 
]

{ #category : #'testing-parsing' }
PPXmlGrammarTest >> testParseWithWhitsepaceAfterProlog [
	self assertParseInvariant: '<?xml version="1.0" encoding="UTF-8"?>
	<schema></schema>
' 
]

{ #category : #'testing-other' }
PPXmlGrammarTest >> testQualifiedName [
	| name |
	name := PPXmlName name: 'prefix:tag'.
	self assertNameInvariant: name.
	self assert: name localName = 'tag'.
	self assert: name namespacePrefix = 'prefix'.
	self assert: name qualifiedName = 'prefix:tag'.
	self assert: name uri isNil
]

{ #category : #'testing-other' }
PPXmlGrammarTest >> testUnqualifiedName [
	| name |
	name := PPXmlName name: 'tag'.
	self assert: name localName = 'tag'.
	self assert: name namespacePrefix isNil.
	self assert: name qualifiedName = 'tag'.
	self assert: name uri isNil
]

{ #category : #'testing-other' }
PPXmlGrammarTest >> testUriName [
	| name |
	name := PPXmlName name: 'prefix:tag' uri: 'http://www.lukas-renggli.ch/'.
	self assertNameInvariant: name.
	self assert: name localName = 'tag'.
	self assert: name namespacePrefix = 'prefix'.
	self assert: name qualifiedName = 'prefix:tag'.
	self assert: name uri = 'http://www.lukas-renggli.ch/'
]
