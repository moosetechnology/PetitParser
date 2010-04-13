Extension { #name : #PPListParser }

{ #category : #'*petitanalyzer-transforming' }
PPListParser >> replace: aParser with: anotherParser [
	super replace: aParser with: anotherParser.
	parsers := parsers collect: [ :each | 
		each == aParser
			ifTrue: [ anotherParser ]
			ifFalse: [ each ] ]
]
