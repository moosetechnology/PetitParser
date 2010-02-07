Extension { #name : #PositionableStream }

{ #category : #'*petitparser-core-converting' }
PositionableStream >> asPetitStream [
	^ PPStream on: collection from: position to: readLimit
]

{ #category : #'*petitparser-core-accessing' }
PositionableStream >> collection [
	^ collection
]
