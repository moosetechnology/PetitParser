Extension { #name : #Collection }

{ #category : #'*PetitParser' }
Collection >> asChoiceParser [
	^ PPChoiceParser withAll: (self collect: [ :each | each asParser ])
]

{ #category : #'*PetitParser' }
Collection >> asParser [    
	"Create a range of characters between start and stop.
	
	This example works and parse the input:
		(#($a $b $c $d $e $f) asParser parse: 'a') >>> $a
	
	This example results in a PPFailure:
		(#($a $b $c $d $e $f) asParser parse: 'g') asString >>> 'One of these charactes expected: #($a $b $c $d $e $f) at 0'
	"

	(self allSatisfy: [ :e | e isCharacter ]) ifTrue: [ 
		| charSet |
		charSet := PPCharSetPredicate on: [ :char | self includes: char ] .
     	^ PPPredicateObjectParser on: charSet message: 'One of these charactes expected: ', self printString.
	].


	^ super asParser

]

{ #category : #'*PetitParser' }
Collection >> asSequenceParser [
	^ PPSequenceParser withAll: (self collect: [ :each | each asParser ])
]
