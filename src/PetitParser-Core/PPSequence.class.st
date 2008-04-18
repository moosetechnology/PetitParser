Class {
	#name : #PPSequence,
	#superclass : #PPList,
	#instVars : [
		'lower',
		'upper'
	],
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPSequence >> , aRule [ 
	parsers add: aRule
]

{ #category : #parsing }
PPSequence >> parse: aStream [
	| position items item |
	position := aStream position.
	items := OrderedCollection new: parsers size.
	parsers do: [ :parser |
		item := parser parse: aStream.
		item class = PPFail
			ifFalse: [ items add: item ]
			ifTrue: [
				aStream position: position.
				^ item ] ].
	^ items asArray
]

{ #category : #printing }
PPSequence >> printOn: aStream [
	parsers
		do: [ :each | aStream print: each ]
		separatedBy: [ aStream space ]
]
