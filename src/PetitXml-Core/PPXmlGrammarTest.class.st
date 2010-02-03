Class {
	#name : #PPXmlGrammarTest,
	#superclass : #PPXmlTest,
	#category : #'PetitXml-Tests'
}

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> parserClass [
	^ PPXmlGrammar
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testDoctype [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE freaking <schema> [ <!-- schema --> ]  >
	<schema></schema>'
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseAll [
	self resource allXsdDefinitions 
		do: [ :each | self assertInvariant: each ]
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseComment [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- comment --></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseCommentWithXml [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- <foo></foo> --></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseComplicated [
	self assertInvariant: '<?xml foo?>
<foo>
	<bar a="fasdfasdf">
		<zork/>
		<zonk/>
	</bar>
	<!-- with comment -->
</foo>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseEmptyElement [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema/>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseNamespace [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?><xs:schema></xs:schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseSimple [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseSimpleAttribute [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?><schema foo="bar"></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseWithWhitsepaceAfterProlog [
	self assertInvariant: '<?xml version="1.0" encoding="UTF-8"?>
	<schema></schema>' 
]
