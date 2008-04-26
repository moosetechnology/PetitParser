Class {
	#name : #PPSchemeParser,
	#superclass : #PPCompositeParser,
	#category : #'PetitParser-Builder'
}

{ #category : #'productions-expressions' }
PPSchemeParser >> application [
	open , selector , expression star , close ==> [ :node | 
		RBMessageNode 
			qqReceiver: node third first 
			selector: node second 
			arguments: node third allButFirst ]
]

{ #category : #'productions-literals' }
PPSchemeParser >> boolean [
		('#t' token ==> [ :node | ``(true) ])
	|	('#f' token ==> [ :node | ``(false) ])
]

{ #category : #tokens }
PPSchemeParser >> close [
	$) token
]

{ #category : #productions }
PPSchemeParser >> expression [
		number
	|	string
	|	boolean
	|	identifier
	|	lambda
	|	application
		
	


]

{ #category : #'productions-literals' }
PPSchemeParser >> identifier [
	#letter plus token ==> [ :node | RBVariableNode named: node copy ]
]

{ #category : #'productions-expressions' }
PPSchemeParser >> if [
		(open , 'if' token , expression , expression , close)
	|	(open , 'if' token , expression , expression , expression , close)
]

{ #category : #'productions-expressions' }
PPSchemeParser >> lambda [
	(open , 'lambda' token , identifier , expression , close) ==> [ :node |
		``[ `,(node fourth) ] arguments: (Array with: ``(`,(node third))) ]
]

{ #category : #'productions-expressions' }
PPSchemeParser >> let [
	
]

{ #category : #'productions-literals' }
PPSchemeParser >> number [
	($- optional , #digit plus , ($. , #digit plus) optional) token
		==> [ :node | ``(`,(Number readFrom: node copy)) ]
]

{ #category : #tokens }
PPSchemeParser >> open [
	$( token
]

{ #category : #'productions-literals' }
PPSchemeParser >> selector [
	#space not plus token ==> [ :node | node copy asSymbol ]
]

{ #category : #productions }
PPSchemeParser >> startProduction [
	expression end
]

{ #category : #'productions-literals' }
PPSchemeParser >> string [
	($" , $" not star , $") token 
		==> [ :node | ``(`,(node copyFrom: 2 to: node size - 1)) ]
]
