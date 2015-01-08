Extension { #name : #PPPushParser }

{ #category : #'*petitislands' }
PPPushParser >> nonEmpty [
	^ PPFailingParser message: 'PUSH always empty'
]
