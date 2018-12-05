Extension { #name : #Interval }

{ #category : #'*PetitParser' }
Interval >> asParser [    
	"Create a range of characters between start and stop.
	
	This example works and parse the input:
		(($a to: $f) asParser parse: 'a') >>> $a
	
	This example results in a PPFailure:
		(($a to: $f) asParser parse: 'g') asString >>> 'One of these charactes expected: #($a $b $c $d $e $f) at 0'
	"

    self assert:start isCharacter.
    self assert:stop isCharacter.
    self assert:step == 1.
    ^ PPPredicateObjectParser between: start and: stop
]
