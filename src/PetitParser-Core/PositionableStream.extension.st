Extension { #name : #PositionableStream }

{ #category : #'*petitparser-core-converting' }
PositionableStream >> asParserStream [
	^ collection asParserStream
]

{ #category : #'*petitparser-core-accessing' }
PositionableStream >> collection [
	^ collection
]
