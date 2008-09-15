Class {
	#name : #PPNotParser,
	#superclass : #PPAndParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPNotParser >> basicParse: aStream [ 
	| element |
	element := super basicParse: aStream.
	^ element isFailure ifFalse: [ PPFailure at: aStream position ]
]

{ #category : #operations }
PPNotParser >> not [
	^ parser
]
