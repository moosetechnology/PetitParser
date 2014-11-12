Class {
	#name : #PPIndentParserTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'indent',
		'input',
		'parser',
		'result'
	],
	#category : #'PetitIndent-Tests'
}

{ #category : #'as yet unclassified' }
PPIndentParserTest >> assert: aParser parse: aCollection to: aTargetObject end: anInteger [
	^ result := super assert: aParser parse: aCollection to: aTargetObject end: anInteger
]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> setUp [
	super setUp.
	indent := #indent asParser
]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> testIndent1 [
	parser  := 'abc' asParser, indent, 'def' asParser.
	input := 'abc
def'.
	
	self assert: parser fail: input.
]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> testIndent2 [
	parser  := 'abc' asParser, indent, 'def' asParser.
	input := 'abc
	def'.
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> testIndent3 [
	parser  :='abc' asParser, indent, 'def' asParser.
	input := 'abc
		def'.
		
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> testIndentAtBeginning [
	parser  := indent, 'abc' asParser, indent , 'def' asParser.
	input := '	abc
		def'.

	self assert: parser parse: input.

]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> testIndentOptional [
	parser  := 'abc' asParser, indent optional, 'def' asParser trim.
	input := 'abc
	def'.
	
	self assert: parser parse: input.

	input := 
'abc
def'.
	
	self assert: parser parse: input.
]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> testIndentStar [
	parser := 'abc' asParser, indent star , 'def' asParser.
	input := 'abc
		def'.
	
	self assert: parser parse: input.
	self assert: result second size = 1.
]

{ #category : #'as yet unclassified' }
PPIndentParserTest >> testTrim1 [
	parser  := 'abc' asParser, indent, 'def' asParser trimWithoutIndents, 'ghi' asParser.
	input := 
'abc
	def
	ghi'.	
		
	self assert: parser parse: input.

]
