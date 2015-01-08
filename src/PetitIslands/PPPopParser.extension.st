Extension { #name : #PPPopParser }

{ #category : #'*petitislands' }
PPPopParser >> nonEmpty [
	^ PPFailingParser message: 'POP always empty'
]
