Class {
	#name : #IndentStack,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
IndentStack >> initialize [
	super initialize.
	contents := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
IndentStack >> isEmpty [
	^ self size = 0
]

{ #category : #'as yet unclassified' }
IndentStack >> pop [
	Halt ifShiftPressed.
	contents isEmpty ifTrue: [ ^ PPFailure message: 'cannot pop an empty stack' ].
	^ contents removeLast
]

{ #category : #copy }
IndentStack >> postCopy [
	super postCopy.
	contents := contents copy.
]

{ #category : #'as yet unclassified' }
IndentStack >> push: anExpression [
	self assert: anExpression isPetitParser.
	^ contents addLast: anExpression
]

{ #category : #'as yet unclassified' }
IndentStack >> replay: context [
	| retval result memento |
	memento := context remember.
	
	retval := OrderedCollection new.
	contents do: [ :p |
"		Transcript crShow:  'parsing: ', p asString."
		result := p parseOn: context.
		result isPetitFailure ifTrue: [
			context restore: memento. 
			^ result
		].
		retval addLast: result.
	].
	^ retval
]

{ #category : #'as yet unclassified' }
IndentStack >> size [
	^ contents size
]

{ #category : #'as yet unclassified' }
IndentStack >> top [
	^ contents last
]
