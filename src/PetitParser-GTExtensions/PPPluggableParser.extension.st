Extension { #name : #PPPluggableParser }

{ #category : #'*PetitParser-GTExtensions' }
PPPluggableParser >> displayName [
	^ String streamContents: [ :stream | block sourceNode printOn: stream ]
]
