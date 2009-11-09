Extension { #name : #PPParser }

{ #category : #'*petitgui-accessing' }
PPParser >> displayColor [
	^ self isUnresolved
		ifTrue: [ Color red ]
		ifFalse: [ 
			self isNullable
				ifTrue: [ Color blue ]
				ifFalse: [ Color black ] ]
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
	^ self morphicShapeSeen: IdentitySet new depth: 2
]

{ #category : #'*petitgui-accessing' }
PPParser >> morphicShapeSeen: aSet depth: anInteger [
	^ TextMorph new
		centered;
		autoFit: true;
		borderWidth: 1;	
		borderColor: Color black;
		backgroundColor: Color white;
		textColor: (self isTerminal
			ifTrue: [ Color purple ]
			ifFalse: [ Color blue ]);
		contents: self displayName;
		yourself
]

{ #category : #'*petitgui-accessing' }
PPParser >> productions [
	^ #()
]
