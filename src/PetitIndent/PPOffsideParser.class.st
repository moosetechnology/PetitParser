Class {
	#name : #PPOffsideParser,
	#superclass : #PPCompareParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPOffsideParser >> compare [
	^ self lastIndent > context stream column.
]

{ #category : #'as yet unclassified' }
PPOffsideParser >> expectedString [
	^ 'column smaller to ', self lastIndent asString
]
