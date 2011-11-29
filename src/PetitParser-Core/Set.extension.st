Extension { #name : #Set }

{ #category : #'*petitparser-core-converting' }
Set >> asParser [
	self notify: 'Set>>#asParser is no longer supported. If you would like to create a PPChoiceParser from a Collection consider using #asChoiceParser instead. Sets have a unpredicatable order and should be avoided'.
	^ self asChoiceParser
]
