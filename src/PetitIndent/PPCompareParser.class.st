Class {
	#name : #PPCompareParser,
	#superclass : #PPIndentationParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPCompareParser >> parseOn: aPPContext [
	| start |
	context := aPPContext.
	start := context stream position.
	self compare ifTrue: [ 
		^ parser parseOn: aPPContext
	].

	^ PPFailure message: 
		'The ', parser asString, ' was expected to be at ', self expectedString, 
		' (reference: ', self ref asString, ')',
		' current line: ', context stream line asString,
		' current column: ', context stream column asString
	 context: aPPContext.
]
