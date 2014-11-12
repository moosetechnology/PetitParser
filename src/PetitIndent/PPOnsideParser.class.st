Class {
	#name : #PPOnsideParser,
	#superclass : #PPCompareParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPOnsideParser >> compare [
	^ self lastIndent <= context stream column.
]

{ #category : #'as yet unclassified' }
PPOnsideParser >> expectedString [
	^ 'column equal or greater to ', self lastIndent asString
]
