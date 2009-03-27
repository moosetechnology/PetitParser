Extension { #name : #PositionableStream }

{ #category : #'*petitparser-core-converting' }
PositionableStream >> asParserStream [
	^ PPStream on: collection from: position to: readLimit
]

{ #category : #'*petitparser-core-accessing' }
PositionableStream >> collection [
	^ collection
]
