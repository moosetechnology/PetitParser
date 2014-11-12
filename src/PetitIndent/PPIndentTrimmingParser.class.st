Class {
	#name : #PPIndentTrimmingParser,
	#superclass : #PPAbstractTrimmingParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPIndentTrimmingParser >> createTrimmingParser: aPPContext [
	| commentsParser |
	commentsParser := self commentsParser: aPPContext.
	
	^ (#indent asParser / #dedent asParser / #codeLayout asParser / #newline asParser) star,
	parser,
	(#indent asParser / #dedent asParser / #codeLayout asParser / #newline asParser) star ==> #second
]
