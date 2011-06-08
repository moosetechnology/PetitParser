Extension { #name : #PPXmlElement }

{ #category : #'*petitxpath-extensions' }
PPXmlElement >> contentDate [ 
	^self contentText asDate
]

{ #category : #'*petitxpath-extensions' }
PPXmlElement >> contentDateAndTime [ 
	^self contentText asTimeStamp 
]

{ #category : #'*petitxpath-extensions' }
PPXmlElement >> contentNumber [ 
	^self contentText asNumber
]

{ #category : #'*petitxpath-extensions' }
PPXmlElement >> contentText [ 
	^self firstChild data
]

{ #category : #'*petitxpath-extensions' }
PPXmlElement >> find: aString [ 
	^self findXPath: (PPXPathParser parse: aString)
]

{ #category : #'*petitxpath-extensions' }
PPXmlElement >> findXPath: nodesCollection [
	| node remaining answer |

	nodesCollection ifEmpty: [ ^self ].
	
	node := nodesCollection first.
	remaining := nodesCollection allButFirst.
	
	answer := node resolveOn: self.
	^answer isCollection 
		ifTrue: [ answer collect: [ :each | each findXPath: remaining ] ]
		ifFalse: [ answer findXPath: remaining ]
]
