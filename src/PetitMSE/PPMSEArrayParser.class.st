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
	
	==> [ :tokens | 
		    (tokens size > 1 or: [ tokens isEmpty ]) 	
				ifTrue: [ tokens asArray ] 
				ifFalse: [ tokens first ]]
]

{ #category : #values }
PPMSEArrayParser >> boolean [ 
	^ super boolean 
	
	==> [:token | token value = 'true' ifTrue: [true] ifFalse: [token value = 'false' ifTrue: [false] ifFalse: [nil]]] 
]

{ #category : #accessing }
PPMSEArrayParser >> element [
	^ super element
	
	==> [:token | Array with: (token at: 2) with: (token at: 3) with: (token at: 4) asArray ]
]

{ #category : #accessing }
PPMSEArrayParser >> elementName [
	^ super elementName
	
	==> [:token | token value ]
]

{ #category : #accessing }
PPMSEArrayParser >> elements [
	^ super elements
	
	==> [:token | token second asArray ]
]

{ #category : #accessing }
PPMSEArrayParser >> id [
	^ super id
	
	==> [:token | Array with: 'id' with: (token at: 3) value asNumber ]
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
PPMSEArrayParser >> natural [
	^ super natural
	
	==> [ :token | token value asNumber ]
]

{ #category : #values }
PPMSEArrayParser >> number [
	^ super number
	
	==> [ :token | (token value copyReplaceAll: 'E' with: 'e') asNumber ]
]

{ #category : #values }
PPMSEArrayParser >> primitive [ 
	^ super primitive
]

{ #category : #accessing }
PPMSEArrayParser >> simpleName [
	^ super simpleName
	
	==> [:token | token value ]
]

{ #category : #values }
PPMSEArrayParser >> string [
	^ super string
		
	==> [ :token | token second ]
]

{ #category : #basic }
PPMSEArrayParser >> stringText [
	^ super stringText
	
	==> [:token | 
		 token value
			copyReplaceAll: ''''''
			with: '''' ]
]
