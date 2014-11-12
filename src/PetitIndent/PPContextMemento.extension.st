Extension { #name : #PPContextMemento }

{ #category : #'*PetitIndent' }
PPContextMemento >> indentTraces [
	^ (self propertyAt: #indentTraces) copy
]

{ #category : #'*PetitIndent' }
PPContextMemento >> indentTraces: anIndentTraces [
	self propertyAt: #indentTraces put: anIndentTraces copy 
]

{ #category : #'*PetitIndent' }
PPContextMemento >> rememberIndentTraces: aPPContext. [
	self indentTraces: aPPContext indentTraces.
]

{ #category : #'*PetitIndent' }
PPContextMemento >> restoreIndentTraces: aPPContext [
	aPPContext indentTraces: self indentTraces
]
