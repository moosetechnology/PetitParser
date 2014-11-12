Class {
	#name : #PPNoIndentTrimmingParser,
	#superclass : #PPAbstractTrimmingParser,
	#category : #'PetitIndent-Core'
}

{ #category : #'as yet unclassified' }
PPNoIndentTrimmingParser >> createTrimmingParser: aPPContext [
	| blanks il trimmer commentsParser |
	il := PPIndentationLevel instance.
	commentsParser := self commentsParser: aPPContext.
	blanks := #codeLayout asParser star.
	
	trimmer := 
	 	  	(#startOfLine asParser not, 
			blanks,
			"Make sure that logical line starts at level equal to indentation level"
	  		((#newline asParser, blanks) plus, (nil asParser alignedTo: il)) optional
	     )
	/
	 	  	(#startOfLine asParser,
			blanks,
			(#newline asParser, blanks) star,
			(nil asParser alignedTo: il)
	     )
	/
		nil asParser.
	
	trimmer disableDebuggerOutput.	
	^ trimmer, parser, trimmer ==> #second
	
	
]
