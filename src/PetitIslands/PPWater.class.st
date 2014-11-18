Class {
	#name : #PPWater,
	#superclass : #PPDelegateParser,
	#instVars : [
		'waterToken',
		'context'
	],
	#category : #'PetitIslands-Parsers'
}

{ #category : #'as yet unclassified' }
PPWater class >> on: parser [
	^ self on: parser waterToken: #any asParser
]

{ #category : #'as yet unclassified' }
PPWater class >> on: parser waterToken: waterToken [
	^ (super on: parser)
		waterToken: waterToken;
		yourself
]

{ #category : #'as yet unclassified' }
PPWater >> checkContext: aPPContext [
	context == aPPContext ifFalse: [ 
		self reset: aPPContext
	]
]

{ #category : #'as yet unclassified' }
PPWater >> children [
	^ Array with: waterToken
]

{ #category : #'as yet unclassified' }
PPWater >> initialize [
	super initialize.
	waterToken := nil asParser.
	context := nil.
]

{ #category : #'as yet unclassified' }
PPWater >> parseOn: aPPContext [
	| waterPosition result |
	
	(aPPContext waterPosition == aPPContext position) ifFalse: [ 
		waterPosition := aPPContext waterPosition.
		aPPContext waterPosition: aPPContext position.

		result := parser parseOn: aPPContext.
		[result isPetitFailure] whileTrue: [
			aPPContext atEnd ifTrue: [ 
				aPPContext waterPosition: waterPosition.
				^ PPFailure message: 'anchor did not found' at: aPPContext position ].
			waterToken parseOn: aPPContext.
			aPPContext waterPosition: aPPContext position.
			result := parser parseOn: aPPContext.
		].
		
		aPPContext waterPosition: waterPosition.
	].

	^ #water
]

{ #category : #'as yet unclassified' }
PPWater >> replace: child with: anotherChild [
	child == waterToken  ifTrue: [ 
		waterToken := anotherChild.
	]
]

{ #category : #'as yet unclassified' }
PPWater >> reset: aPPContext [
	| waterObjects |
	
	context := aPPContext.

	waterObjects := aPPContext globalAt: #waterObjects ifAbsent: [ OrderedCollection new ].
	waterObjects add: #any asParser.
	waterToken := PPChoiceParser withAll: waterObjects.

]

{ #category : #'as yet unclassified' }
PPWater >> waterToken: aPPParser [
	^ waterToken := aPPParser
]
