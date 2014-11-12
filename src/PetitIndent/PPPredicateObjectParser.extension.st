Extension { #name : #PPPredicateObjectParser }

{ #category : #'*PetitIndent' }
PPPredicateObjectParser class >> codeLayout [
	
	^ PPLayoutParser new.
]

{ #category : #'*PetitIndent' }
PPPredicateObjectParser class >> dedent [
	
	^ PPDedentParser new
]

{ #category : #'*PetitIndent' }
PPPredicateObjectParser class >> indent [
	^ PPIndentParser new
]
