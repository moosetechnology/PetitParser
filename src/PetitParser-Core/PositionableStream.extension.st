Extension { #name : #PositionableStream }

{ #category : #'*petitparser-core-converting' }
PositionableStream >> asParserStream [
	^ self contents asParserStream
]

{ #category : #'*petitparser-core-accessing' }
PositionableStream >> collection [
	^ collection
]
