Class {
	#name : #PPTolerantOnsideParser,
	#superclass : #PPCompareParser,
	#instVars : [
		'tolerance'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPTolerantOnsideParser >> compare [
	^ self lastIndent - tolerance <= context stream column.
]

{ #category : #'as yet unclassified' }
PPTolerantOnsideParser >> expectedString [
	^ 'column equal or greater to ', self lastIndent asString, ' with tolerance ', tolerance asString
]

{ #category : #'as yet unclassified' }
PPTolerantOnsideParser >> intitialize [
	super initialize.
	tolerance := 0
]

{ #category : #'as yet unclassified' }
PPTolerantOnsideParser >> tolerance [
	^ tolerance
]

{ #category : #'as yet unclassified' }
PPTolerantOnsideParser >> tolerance: anInteger [
	tolerance := anInteger
]
