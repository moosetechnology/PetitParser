Class {
	#name : #PPAlignedParser,
	#superclass : #PPCompareParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPAlignedParser >> compare [
	^ self lastIndent == context stream column.
]

{ #category : #'as yet unclassified' }
PPAlignedParser >> expectedString [
	^ 'column equal to ', self lastIndent asString.
]
