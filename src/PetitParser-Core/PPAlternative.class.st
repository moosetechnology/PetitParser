Class {
	#name : #PPAlternative,
	#superclass : #PPList,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPAlternative >> parse: aStream [
	| item |
	parsers do: [ :parser |
		item := parser parse: aStream.
		item class = PPFail
			ifFalse: [ ^ item ] ].
	^ item
]

{ #category : #printing }
PPAlternative >> printOn: aStream [
	parsers
		do: [ :each | aStream print: each ]
		separatedBy: [ aStream nextPutAll: ' | ' ]
]

{ #category : #operations }
PPAlternative >> | aRule [ 
	parsers add: aRule
]
