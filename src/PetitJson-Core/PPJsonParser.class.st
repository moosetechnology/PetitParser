Class {
	#name : #PPJsonParser,
	#superclass : #PPJsonGrammar,
	#category : #'PetitJson-Core'
}

{ #category : #grammar }
PPJsonParser >> array [
	^ super array ==> [ :nodes | Array withAll: (nodes second ifNil: [ #() ]) ]
]

{ #category : #primitives }
PPJsonParser >> charEscape [
	^ $\ asParser , #any asParser
]

{ #category : #grammar }
PPJsonParser >> elements [
	^ super elements ==> [ :nodes | nodes reject: [ :each | each isKindOf: PPToken ] ]
]

{ #category : #tokens }
PPJsonParser >> falseToken [
	^ super falseToken ==> [ :token | false ]
]

{ #category : #grammar }
PPJsonParser >> members [
	^ super members ==> [ :nodes | nodes reject: [ :each | each isKindOf: PPToken ] ]
]

{ #category : #tokens }
PPJsonParser >> nullToken [
	^ super nullToken  ==> [ :token | nil ]
]

{ #category : #tokens }
PPJsonParser >> numberToken [
	^ super numberToken ==> [ :token | (token value copyWithout: $+) asNumber ]
]

{ #category : #grammar }
PPJsonParser >> object [
	^ super object ==> [ :nodes |
		(nodes second ifNil: [ #() ])
			inject: Dictionary new
			into: [ :result :each | 
				result
					add: each;
					yourself ] ]
]

{ #category : #grammar }
PPJsonParser >> pair [
	^ super pair map: [ :key :sep :val | key -> val ]
]

{ #category : #tokens }
PPJsonParser >> stringToken [
	^ super stringToken ==> [ :token | token value copyFrom: 2 to: token value size - 1 ]
]

{ #category : #tokens }
PPJsonParser >> trueToken [
	^ super trueToken ==> [ :token | true ]
]
