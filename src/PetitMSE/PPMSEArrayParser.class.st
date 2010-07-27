Class {
	#name : #PPMSEArrayParser,
	#superclass : #PPMSEGrammar,
	#category : #PetitMSE
}

{ #category : #accessing }
PPMSEArrayParser >> attribute [
	^ super attribute 
	
	==> [:token | Array with: (token at: 2) with: (token at: 3) ]
]

{ #category : #accessing }
PPMSEArrayParser >> attributeValue [
	^ super attributeValue
]

{ #category : #values }
PPMSEArrayParser >> boolean [ 
	^ super boolean 
	
	==> [:token | token = 'true' ifTrue: [true] ifFalse: [token = 'false' ifTrue: [false] ifFalse: [nil]]] 
]

{ #category : #accessing }
PPMSEArrayParser >> element [
	^ super element
	
	==> [:token | Array with: (token at: 2) with: (token at: 3) with: (token at: 4) ]
]

{ #category : #accessing }
PPMSEArrayParser >> elements [
	^ super elements
	
	==> [:token | token second ]
]

{ #category : #accessing }
PPMSEArrayParser >> id [
	^ super id
	
	==> [:token | Array with: 'id' with: (token at: 3) asNumber ]
]

{ #category : #accessing }
PPMSEArrayParser >> identifierName [
	^ super identifierName
	
	==> [:token | 
		token second isNil 
			ifTrue: [ token first ] 
			ifFalse: [ token first, token second ] ]
]

{ #category : #values }
PPMSEArrayParser >> number [
	^ super number
	
	==> [ :token | token value asNumber ]
]

{ #category : #values }
PPMSEArrayParser >> primitive [ 
	^ super primitive
]

{ #category : #values }
PPMSEArrayParser >> reference [ 
	^ super reference

	==> [:token | Array with: 'ref' with: (token at: 3) asNumber ]
]

{ #category : #values }
PPMSEArrayParser >> string [ 
	^ super string
	
	==> [:token | token second ]
]
