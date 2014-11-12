Class {
	#name : #PPIndentParser,
	#superclass : #PPParser,
	#instVars : [
		'parser'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPIndentParser >> acceptsEpsilon [
	^ false
]

{ #category : #'as yet unclassified' }
PPIndentParser >> isIndentationParser [
	^ true
]

{ #category : #'as yet unclassified' }
PPIndentParser >> name [
	^ #indent
]

{ #category : #'as yet unclassified' }
PPIndentParser >> parseOn: aPPContext [
	^ self parser parseOn: aPPContext.

]

{ #category : #'as yet unclassified' }
PPIndentParser >> parser [
	| il |
	il := PPIndentationLevel instance.
	parser ifNil: [ 
		parser := #newline asParser optional, 
			(#startOfLine asParser, #codeLayout asParser star),
			(#newline asParser, #startOfLine asParser, #codeLayout asParser star) star,
			il strictlyOnside,
			il push
				==> [ :tokens | #indent ]   
	].
	^ parser

]

{ #category : #'as yet unclassified' }
PPIndentParser >> ref [
	^ PPIndentationLevel instance
]
