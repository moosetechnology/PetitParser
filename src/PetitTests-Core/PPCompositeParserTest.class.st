Class {
	#name : #PPCompositeParserTest,
	#superclass : #PPAbstractParseTest,
	#instVars : [
		'parser'
	],
	#category : #'PetitTests-Core'
}

{ #category : #testing }
PPCompositeParserTest class >> isAbstract [
	^ self name = #PPCompositeParserTest
]

{ #category : #accessing }
PPCompositeParserTest class >> resources [
	^ Array with: PPParserResource
]

{ #category : #utilities }
PPCompositeParserTest >> assert: aCollection is: anObject [
	| result |
	result := self parse: aCollection.
	self
		assert: result = anObject
		description: 'Got: ' , result printString , '; Expected: ' , anObject printString
		resumable: true
]

{ #category : #utilities }
PPCompositeParserTest >> parse: aString [
	^ parser
		parse: aString
		onError: [ :err :pos | self error: err ]
]

{ #category : #utilities }
PPCompositeParserTest >> parse: aString production: aSymbol [
	^ (parser productionAt: aSymbol)
		parse: aString
		onError: [ :err :pos | self error: err ].
]

{ #category : #accessing }
PPCompositeParserTest >> parserClass [
	self subclassResponsibility
]

{ #category : #accessing }
PPCompositeParserTest >> parserInstance [
	^ PPParserResource current parserAt: self parserClass
]

{ #category : #running }
PPCompositeParserTest >> setUp [
	super setUp.
	parser := self parserInstance
]
