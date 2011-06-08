Extension { #name : #PPXmlDocument }

{ #category : #'*petitxpath-extensions' }
PPXmlDocument >> find: aString [
	^self lastChild find: aString
]
