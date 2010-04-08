Extension { #name : #PositionableStream }

{ #category : #'*petitparser-core-converting' }
PositionableStream >> asPetitStream [
	"Some of my subclasses do not use the instance-variables collection, position and readLimit but instead have a completely different internal representation. In these cases just use the super implementation that is inefficient but should work in all cases."

	^ (collection isNil or: [ position isNil or: [ readLimit isNil ] ])
		ifFalse: [ PPStream on: collection from: position to: readLimit ]
		ifTrue: [ super asPetitStream ]
]

{ #category : #'*petitparser-core-accessing' }
PositionableStream >> collection [
	^ collection
]
