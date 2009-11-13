Extension { #name : #PPDelegateParser }

{ #category : #'*petitgui-accessing' }
PPDelegateParser >> displayDescription [
	^ nil
]

{ #category : #'*petitgui-accessing' }
PPDelegateParser >> exampleOn: aStream [
	parser exampleOn: aStream
]

{ #category : #'*petitgui-accessing' }
PPDelegateParser >> morphicShapeSeen: aSet depth: anInteger [
	^ self morphicShapeSeen: aSet depth: anInteger do: [ :cc |
		self displayDescription isNil
			ifTrue: [ cc value: parser ]
			ifFalse: [
				AlignmentMorph newColumn
					cellInset: 0 @ 5;
					layoutInset: 0 @ 5;	
					vResizing: #shrinkWrap;
					color: (self backgroundForDepth: anInteger);
					addMorphBack: (StringMorph contents: self displayDescription);
					addMorphBack: (AlignmentMorph newRow
						cellInset: 0;
						layoutInset: 0;					
						vResizing: #shrinkWrap;
						color: Color transparent;
						addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) makeForwardArrow;
						addMorphBack: (cc value: parser);
						addMorphBack: (LineMorph from: 0 @ 0 to: 20 @ 0 color: Color black width: 1) makeForwardArrow;
						yourself);
					addMorphBack: (StringMorph contents: String new);
					yourself ] ]
]
