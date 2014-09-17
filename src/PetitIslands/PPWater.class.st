Class {
	#name : #PPWater,
	#superclass : #PPDelegateParser,
	#category : #'PetitIslands-Parsers'
}

{ #category : #'as yet unclassified' }
PPWater >> children [
	^ #()
]

{ #category : #'as yet unclassified' }
PPWater >> initialize [
	super initialize.
]

{ #category : #'as yet unclassified' }
PPWater >> parseOn: aPPContext [
	| waterPosition result waterToken root |
	
	(aPPContext waterPosition == aPPContext position) ifFalse: [ 
		waterPosition := aPPContext waterPosition.
		aPPContext waterPosition: aPPContext position.
		root := aPPContext root.
	
		waterToken := self waterToken: aPPContext.
		
		"TODO: probably can be rewritten with test in the end!"
		result := parser parseOn: aPPContext.
		[result isPetitFailure] whileFalse: [ 
			waterToken parseWithContext: aPPContext.
			aPPContext root: root.
			aPPContext waterPosition: aPPContext position.
			result := parser parseOn: aPPContext.
		].
		
		aPPContext waterPosition: waterPosition.
	].

	^ #water
]

{ #category : #'as yet unclassified' }
PPWater >> waterToken: aPPContext [
	| waterObjects |

	waterObjects := aPPContext globalAt: #waterObjects ifAbsent: [ OrderedCollection new ].
	waterObjects add: #any asParser.
	^ PPChoiceParser withAll: waterObjects.
]
