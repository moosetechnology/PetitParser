Class {
	#name : #PPCompositeParserTest,
	#superclass : #PPAbstractParserTest,
	#instVars : [
		'parser',
		'result'
	],
	#category : 'PetitTests-Core'
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
	self parse: aCollection.
	self
		assert: result = anObject
		description: 'Got: ' , result printString , '; Expected: ' , anObject printString
		resumable: true
]

{ #category : #parsing }
PPCompositeParserTest >> fail: aString rule: aSymbol [ 
	| production context |
	production := self parserInstanceFor: aSymbol.
	context := self context.
	
	result := production end parse: aString withContext: context.
	
	self
		assert: result isPetitFailure
		description: 'Able to parse ' , aString printString.
	^ result
]

{ #category : #parsing }
PPCompositeParserTest >> parse: aString [ 
	^ self parse: aString rule: #start
]

{ #category : #parsing }
PPCompositeParserTest >> parse: aString rule: aSymbol [
	| production context |
	production := self parserInstanceFor: aSymbol.
	context := self context.
	
	result := production end parse: aString withContext: context.
	self
		deny: result isPetitFailure
		description: 'Unable to parse ' , aString printString.
	^ result
]

{ #category : #accessing }
PPCompositeParserTest >> parserClass [
	self subclassResponsibility
]

{ #category : #accessing }
PPCompositeParserTest >> parserInstance [
	^ PPParserResource current parserAt: self parserClass
]

{ #category : #accessing }
PPCompositeParserTest >> parserInstanceFor: aSymbol [
	^ aSymbol = #start
		ifTrue: [ self parserInstance ]
		ifFalse: [
			self parserInstance
				productionAt: aSymbol 
				ifAbsent: [ self error: 'Production ' , self parserClass name , '>>' , aSymbol printString , ' not found.' ] ]
]

{ #category : #running }
PPCompositeParserTest >> setUp [
	super setUp.
	parser := self parserInstance
]

{ #category : #running }
PPCompositeParserTest >> tearDown [
	super tearDown.
	parser := result := nil
]
