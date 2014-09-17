Class {
	#name : #XmlFeedParserTest,
	#superclass : #PPCompositeParserTest,
	#instVars : [
		'debugResult'
	],
	#category : #'PetitIslands-Examples'
}

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> debug: aString rule: aSymbol [
	| production |
	production := self parserInstanceFor: aSymbol.
	debugResult := production end debug: aString.
	result := debugResult children first result.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	^ result
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> feed01 [
	^ LanguageSources new xmlFeed01
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> feed02 [
	^ LanguageSources new xmlFeed02
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> feed03 [
	^ LanguageSources new xmlFeed03
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> parse: aString rule: aSymbol to: anObject [
	| production |
	production := self parserInstanceFor: aSymbol.
	result := production end parse: aString.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	self assert: result = anObject.
	
	^ result
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> parserClass [
	^ XmlFeedParser
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testItem [
	self testItem01.
	self testItem02.
	self testItem03.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testItem01 [
	self debug: '
	<item>
		<name>abc</name>
	</item>
	' rule: #item.
	
	self assert: (result at: #name) = 'abc'.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testItem02 [
	self debug: '
	<item>
		<name>abc</name>
		<price>123</price>
	</item>
	' rule: #item.
	
	self assert: (result at: #name) = 'abc'.
	self assert: (result at: #price) = '123'.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testItem03 [
	self debug: '
	<item>
		<price>123</price>
		<name>abc</name>
	</item>
	' rule: #item.
	
	self assert: (result at: #name) = 'abc'.
	self assert: (result at: #price) = '123'.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testShoplist [
	self testShoplist01.
	self testShoplist02.
	self testShoplist03.
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testShoplist01 [
	self debug: '
<shoplist>
	<item>
		<name>abc</name>
	</item>
</shoplist>
	' rule: #shoplist.
	
	self assert: result size = 1.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testShoplist02 [
	self debug: '
<shoplist>
	<name>xyz</name>
	<item>
		<name>abc</name>
		<price>123</price>
	</item>
</shoplist>
	' rule: #shoplist.
	
	self assert: result size = 1.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testShoplist03 [
	self debug: '
<shoplist>
	<name>xyz</name>
	<item>
		<name>abc</name>
		<price>123</price>
	</item>
	<item>
		<name>cde</name>
		<price>345</price>
	</item>
</shoplist>
	' rule: #shoplist.
	
	self assert: result size = 2.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testSimpleElement [
	self parse: '<a>b</a>' rule: #simpleElement to: #('a' 'b').	
	self parse: '<abc> def </ abc>' rule: #simpleElement to: #('abc' 'def').	
		
	self fail: '<a>b</b>' rule: #simpleElement.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testStringValue [
	self parse: 'abc' rule: #stringValue to: 'abc'.	
	self parse: ' def ' rule: #stringValue to: 'def'.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testXmlFeed01 [
	self parse: self feed01.
	
	self assert: result size = 1.
	self assert: (result first at:#name) = 'socks'.
	self assert: (result first at:#price) = '123'.
	self assert: (result first at:#availability) = '1'.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testXmlFeed02 [
	self parse: self feed02.
	
	self assert: result size = 2.
	self assert: (result first at:#name) = 'socks'.
	self assert: (result first at:#price) = '123'.
	self assert: (result first at:#availability) = '1'.

	self assert: (result second at:#name) = 'shoes'.
	self assert: (result second at:#price) = '2345'.
	self assert: (result second at:#availability) = '1'.
	
]

{ #category : #'as yet unclassified' }
XmlFeedParserTest >> testXmlFeed03 [
	self parse: self feed03.
	
	self assert: result size = 2.
	self assert: (result first at:#name) = 'socks'.
	self assert: (result first at:#price) = '123'.
	self assert: (result first at:#availability) = '1'.

	self assert: (result second at:#name) = 'shoes'.
	self assert: (result second at:#price) = '3456'.
	self assert: (result second at:#availability) = '0'.
	
]
