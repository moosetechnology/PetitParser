Extension { #name : #PPParser }

{ #category : #'*petitgui-accessing' }
PPParser >> backgroundForDepth: anInteger [
	^ Color gray: 1.0 - (anInteger / 20.0)
]

{ #category : #'*petitgui-accessing' }
PPParser >> displayColor [
	^ self isLeaf
		ifTrue: [ Color purple ]
		ifFalse: [ Color black ]
]

{ #category : #'*petitgui-accessing' }
PPParser >> displayName [
	^ self name isNil
		ifFalse: [ self name asString ]
		ifTrue: [ self class name asString ]
]

{ #category : #'*petitgui-accessing' }
PPParser >> example [
	^ String streamContents: [ :stream | self exampleOn: stream ] limitedTo: 1024
]

{ #category : #'*petitgui-accessing' }
PPParser >> exampleOn: aStream [
]

{ #category : #'*petitgui-accessing' }
PPParser >> morphicShape [
	^ self morphicShapeSeen: IdentitySet new depth: 0
]

{ #category : #'*petitgui-accessing' }
PPParser >> morphicShapeDefault [
	^ AlignmentMorph new
		borderWidth: 1;
		color: Color white;
		borderColor: Color black;
		addMorph: ((StringMorph contents: self displayName)
			color: (self isLeaf 
				ifTrue: [ Color purple ] 
				ifFalse: [ Color blue ])
			yourself);
		vResizing: #shrinkWrap;
		listCentering: #center;
		yourself
]

{ #category : #'*petitgui-accessing' }
PPParser >> morphicShapeSeen: aSet depth: anInteger [
	^ self morphicShapeDefault
]

{ #category : #'*petitgui-accessing' }
PPParser >> morphicShapeSeen: aSet depth: anInteger do: aBlock [
	" avoid recursion "
	(aSet includes: self)
		ifTrue: [ ^ self morphicShapeDefault ].
	" display nice name when possible "
	(anInteger > 0 and: [ self name notNil ]) 
		ifTrue: [ ^ self morphicShapeDefault ].
	" don't do it too deep "
	(anInteger > 10)
		ifTrue: [ ^ self morphicShapeDefault ].
	aSet add: self. 
	^ aBlock value: [ :parser |
		parser 
			morphicShapeSeen: aSet 
			depth: anInteger + 1 ]
]
