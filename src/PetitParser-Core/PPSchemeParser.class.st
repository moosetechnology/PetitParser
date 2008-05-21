Class {
	#name : #PPSchemeParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'open',
		'close',
		'boolean',
		'character',
		'number',
		'string',
		'list'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #grammar }
PPSchemeParser >> body [
	
]

{ #category : #'grammar-literals' }
PPSchemeParser >> boolean [
	"The standard boolean objects for true and false have external representations #t and #f."

	^ ('#t' asParser | '#f' asParser) flatten ==> [ :each | each = '#t' ]
]

{ #category : #'grammar-literals' }
PPSchemeParser >> character [
	"Characters are represented using the notation #\<character>."

	^ ('#\' asParser , #any asParser) flatten ==> #second
]

{ #category : #token }
PPSchemeParser >> close [
	^ $) asParser token
]

{ #category : #'grammar-expression' }
PPSchemeParser >> definition [
	
]

{ #category : #token }
PPSchemeParser >> false [
	^ 'false' asParser token
]

{ #category : #token }
PPSchemeParser >> id [
	^ (#letter asParser , (#word asParser | $- asParser) star) token
]

{ #category : #'grammar-expression' }
PPSchemeParser >> lambda [
	
]

{ #category : #'grammar-expression' }
PPSchemeParser >> let [
	
]

{ #category : #'grammar-literals' }
PPSchemeParser >> number [
	"The syntax of external representations for number objects is described formally by the <number> rule in the formal grammar."

	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser star) optional) flatten ==> #asNumber
]

{ #category : #token }
PPSchemeParser >> open [
	^ $( asParser token
]

{ #category : #accessing }
PPSchemeParser >> start [
	^ atom | expression
]

{ #category : #'grammar-literals' }
PPSchemeParser >> string [
	"String are represented by sequences of characters enclosed within doublequotes."

	^ ($" asParser , $" asParser not star , $" asParser) flatten ==> [ :value | value copyFrom: 2 to: value size - 1 ]
]

{ #category : #token }
PPSchemeParser >> true [
	^ 'true' asParser token
]
