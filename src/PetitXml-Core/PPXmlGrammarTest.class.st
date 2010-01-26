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
PPXmlGrammarTest >> testParseAll [
	self resource allXsdDefinitions 
		do: [ :each | self parse: each ]
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseComment [
	self parse: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- comment --></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseCommentWithXml [
	self parse: '<?xml version="1.0" encoding="UTF-8"?><schema><!-- <foo></foo> --></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseComplicated [
	self parse: '<?xml foo?>
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
	self parse: '<?xml version="1.0" encoding="UTF-8"?><schema/>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseSimple [
	self parse: '<?xml version="1.0" encoding="UTF-8"?><schema></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseSimpleAttribute [
	self parse: '<?xml version="1.0" encoding="UTF-8"?><schema foo="bar"></schema>' 
]

{ #category : #'as yet unclassified' }
PPXmlGrammarTest >> testParseWithWhitsepaceAfterProlog [
	self parse: '<?xml version="1.0" encoding="UTF-8"?>
	<schema></schema>' 
]
