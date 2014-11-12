Class {
	#name : #PPSmartTrimmingParser,
	#superclass : #PPAbstractTrimmingParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPSmartTrimmingParser >> parseOn: aPPContext [
	| firstTrimmer secondTrimmer |
	firstTrimmer := (parser not, #space asParser) star.
	secondTrimmer := ((parser next: aPPContext) not, #space asParser) star.
	
	^ (firstTrimmer, parser, secondTrimmer ==> #second) parseOn: aPPContext
]
