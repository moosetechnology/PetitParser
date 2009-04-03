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
PPChoiceParser >> parse: aStream [
	| elements element |
	elements := Array new: parsers size.
	1 to: parsers size do: [ :index |
		element := (parsers at: index)
			parse: aStream.
		element isFailure 
			ifFalse: [ ^ element ].
		elements at: index put: element ].
	^ elements detectMax: [ :each | each position ]
]
