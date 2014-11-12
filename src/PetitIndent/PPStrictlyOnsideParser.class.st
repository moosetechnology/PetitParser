Class {
	#name : #PPStrictlyOnsideParser,
	#superclass : #PPCompareParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPStrictlyOnsideParser >> compare [
	^ self lastIndent < context stream column.
]

{ #category : #'as yet unclassified' }
PPStrictlyOnsideParser >> expectedString [
	^ 'column greater to ', self lastIndent asString
]
