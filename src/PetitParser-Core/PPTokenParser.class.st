"
A parser that produces a token from the range my delegate parses.
"
Class {
	#name : #PPTokenParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Core'
}

{ #category : #parsing }
PPTokenParser >> parse: aStream [
	| start stop element |
	start := aStream position.
	element := super parse: aStream.
	element isFailure ifTrue: [ ^ element ].
	stop := aStream position.
	[ aStream atEnd not and: [ aStream peek isSeparator ] ]
		whileTrue: [ aStream next ].
	^ aStream collection sliceFrom: start + 1 to: stop
]
