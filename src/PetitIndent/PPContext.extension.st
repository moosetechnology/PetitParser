Extension { #name : #PPContext }

{ #category : #'*PetitIndent' }
PPContext >> indentTraces [
	^ self propertyAt: #indentTraces ifAbsentPut: [ IndentTraces new stream: self stream; yourself ]
]

{ #category : #'*PetitIndent' }
PPContext >> indentTraces: anIndentTraces [
	^ self propertyAt: #indentTraces put: anIndentTraces
]

{ #category : #'*PetitIndent' }
PPContext >> indexes [
	^ self propertyAt: #indexes ifAbsentPut: [ Indexes new ]
]

{ #category : #'*PetitIndent' }
PPContext >> indexes: anIndexes [
	^ self propertyAt: #indexes put: anIndexes 
]

{ #category : #'*PetitIndent' }
PPContext >> lastIndent [
	^ self indentTraces lastIndent
]
