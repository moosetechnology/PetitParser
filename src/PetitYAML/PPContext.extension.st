Extension { #name : #PPContext }

{ #category : #'*PetitYAML' }
PPContext >> YAMLChomp [
	^ self propertyAt: #YAMLChomp ifAbsent: #'keep'
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLChomp: whatever [
	self propertyAt: #YAMLChomp put: whatever
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLContext [
	^ self propertyAt: #YAMLContext ifAbsent: #'flow-in'
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLContext: whatever [
	self propertyAt: #YAMLContext put: whatever
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLM [
	^ self indentTraces top: #YAMLM
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLM: whatever [
	Halt ifShiftPressed.
	self indentTraces push: #YAMLM column: whatever
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLN [
	^ self indentTraces top: #YAMLN
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLN: whatever [
	self indentTraces push: #YAMLN column: whatever
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLRestoreM [
	^ self indentTraces pop: #YAMLM
]

{ #category : #'*PetitYAML' }
PPContext >> YAMLRestoreN [
	^ self indentTraces pop: #YAMLN
]
