"
A parser that uses the first parser that succeeds.
"
Class {
	#name : #PPChoiceParser,
	#superclass : #PPListParser,
	#category : #'PetitParser-Core'
}

{ #category : #operations }
PPChoiceParser >> / aRule [ 
	^ self copyWith: aRule
]

{ #category : #parsing }
PPChoiceParser >> basicParse: aStream [
	| elements element |
	elements := Array new: parsers size.
	parsers keysAndValuesDo: [ :index :each |
		element := each parse: aStream.
		element isFailure 
			ifFalse: [ ^ element ].
		elements at: index put: element ].
	^ elements detectMax: [ :each | each position ]
]
