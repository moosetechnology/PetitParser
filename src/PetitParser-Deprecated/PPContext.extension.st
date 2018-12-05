Extension { #name : #PPContext }

{ #category : #'*PetitParser-Deprecated' }
PPContext class >> on: aPPParser stream: aStream [
	self deprecated: 'This method is not working. It should not be referenced from your project nor be called.'.
	^ self basicNew 
		initialize;
		root: aPPParser;
		stream: aStream asPetitStream;
		yourself
]
