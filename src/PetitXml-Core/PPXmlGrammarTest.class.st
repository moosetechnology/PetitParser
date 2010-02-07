Class {
	#name : #PPXmlGrammarTest,
	#superclass : #PPXmlTest,
	#category : #'PetitXml-Tests'
}

{ #category : #accessing }
PPXmlGrammarTest >> parserClass [
	^ PPXmlGrammar
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
