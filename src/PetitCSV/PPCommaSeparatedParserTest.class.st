Class {
	#name : #PPCommaSeparatedParserTest,
	#superclass : #PPCompositeParserTest,
	#instVars : [
		'row',
		'cell',
		'rows'
	],
	#category : #PetitCSV
}

{ #category : #'as yet unclassified' }
PPCommaSeparatedParserTest >> parserClass [
	^ PPCommaSeparatedParser
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParserTest >> testSingleLine [
	self assert: '1 , 2, 3' is: #((1 2 3))
]

{ #category : #'as yet unclassified' }
PPCommaSeparatedParserTest >> testTwoLines [
	self assert: '1
2' is: #((1) (2))
]
