Extension { #name : #PositionableStream }

{ #category : #'*petitparser-core-converting' }
PositionableStream >> asPetitStream [
	^ (collection isNil or: [ position isNil or: [ readLimit isNil ] ])
		ifFalse: [ PPStream on: collection from: position to: readLimit ]
		ifTrue: [ super asPetitStream ]
]

{ #category : #'*petitparser-core-accessing' }
PositionableStream >> collection [
	^ collection
]
