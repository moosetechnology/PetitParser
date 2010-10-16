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
PPMSEArrayParser >> attributeName [
	^ super attributeName
	
	==> [:token | token value ]
]

{ #category : #accessing }
PPMSEArrayParser >> attributeValue [
	^ super attributeValue
]

{ #category : #values }
PPMSEArrayParser >> boolean [ 
	^ super boolean 
	
	==> [:token | token value = 'true' ifTrue: [true] ifFalse: [token value = 'false' ifTrue: [false] ifFalse: [nil]]] 
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
	
	==> [:token | Array with: 'id' with: (token at: 3) value asNumber ]
]

{ #category : #accessing }
PPMSEArrayParser >> identifierName [
	^ super identifierName
	
	==> [:token | token value ]
]

{ #category : #values }
PPMSEArrayParser >> integerReference [ 
	^ super integerReference

	==> [:token | Array with: 'ref' with: token "(token at: 3) asNumber" ]
]

{ #category : #values }
PPMSEArrayParser >> nameReference [ 
	^ super nameReference

	==> [:token | Array with: 'ref' with: token ]
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
PPMSEArrayParser >> string [ 
	^ super string
	
	==> [:token | 
		 token value
			copyReplaceAll: ''''''
			with: '''' ]
]
