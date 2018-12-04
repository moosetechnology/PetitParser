Extension { #name : #PPFailure }

{ #category : #'*petitgui' }
PPFailure class >> gtExampleEmptyMessage [
	<gtExample>
	<label: 'Failure: empty'>
	
	^ self message: ''
]

{ #category : #'*petitgui' }
PPFailure class >> gtExampleNumberExpected [
	<gtExample>
	<label: 'Failure: Number expected'>
	
	^ #digit asParser plus parse: 'a'
]
