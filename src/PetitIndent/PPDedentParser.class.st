Class {
	#name : #PPDedentParser,
	#superclass : #PPParser,
	#instVars : [
		'parser'
	],
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPDedentParser >> acceptsEpsilon [
	^ false
]

{ #category : #'as yet unclassified' }
PPDedentParser >> isIndentationParser [
	^ true
]

{ #category : #'as yet unclassified' }
PPDedentParser >> name [
	^ #dedent
]

{ #category : #'as yet unclassified' }
PPDedentParser >> parseOn: aPPContext [
	^ self parser parseOn: aPPContext.
	
]

{ #category : #'as yet unclassified' }
PPDedentParser >> parser [
	parser ifNil: [ 
		| il |
		il := PPIndentationLevel instance.
		
		parser :=
		( 
			"If you can align with a stack, consume whitespaces"
			(il pop,
			 #newline asParser optional, 
			(#startOfLine asParser, #codeLayout asParser star),
			(#newline asParser, #startOfLine asParser, #codeLayout asParser star) star,
			(nil asParser alignedTo: il) )
		/
			"If you don't align with a stack, don't consume anything" 
			(il pop,
			(
			  #newline asParser optional, 
			 (#startOfLine asParser, #codeLayout asParser star),
			 (#newline asParser, #startOfLine asParser, #codeLayout asParser star) star,
			 (nil asParser offsideTo: il) 
			) and) 
		) ==> [ :tokens | #dedent ]   
	].
	^ parser

]

{ #category : #'as yet unclassified' }
PPDedentParser >> ref [
	^ PPIndentationLevel instance
]
