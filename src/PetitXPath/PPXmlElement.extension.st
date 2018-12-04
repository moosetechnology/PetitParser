Extension { #name : #PPXmlElement }

{ #category : #'*PetitXPath' }
PPXmlElement >> contentDate [ 
	^self contentText asDate
]

{ #category : #'*PetitXPath' }
PPXmlElement >> contentDateAndTime [ 
	^self contentText asTimeStamp 
]

{ #category : #'*PetitXPath' }
PPXmlElement >> contentNumber [ 
	^self contentText asNumber
]

{ #category : #'*PetitXPath' }
PPXmlElement >> contentText [ 
	^ self firstChild 
		ifNotNil: [ :child | child data ]
]
