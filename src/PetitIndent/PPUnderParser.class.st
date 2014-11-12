Class {
	#name : #PPUnderParser,
	#superclass : #PPCompareParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPUnderParser >> compare [
	^ self lastLine < context stream line.
]

{ #category : #'as yet unclassified' }
PPUnderParser >> expectedString [
	^ 'line greater to ', self lastLine asString
]
