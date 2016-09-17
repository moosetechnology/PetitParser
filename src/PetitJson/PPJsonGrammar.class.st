Class {
	#name : #PPJsonGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'members',
		'pair',
		'string',
		'value',
		'elements',
		'number',
		'object',
		'array',
		'trueToken',
		'falseToken',
		'nullToken',
		'char',
		'stringToken',
		'numberToken',
		'charEscape',
		'charNormal',
		'charOctal'
	],
	#classVars : [
		'CharacterTable'
	],
	#category : #'PetitJson-Core'
}

{ #category : #initialization }
PPJsonGrammar class >> initialize [
	CharacterTable := Dictionary new.
	CharacterTable
		at: $\ put: $\;
		at: $/ put: $/;
		at: $" put: $";
		at: $b put: Character backspace;
		at: $f put: Character newPage;
		at: $n put: Character lf;
		at: $r put: Character cr;
		at: $t put: Character tab
]

{ #category : #grammar }
PPJsonGrammar >> array [
	^ $[ asParser2 token trim , elements optional , $] asParser2 token trim
]

{ #category : #primitives }
PPJsonGrammar >> char [
	^ charEscape / charOctal / charNormal
]

{ #category : #primitives }
PPJsonGrammar >> charEscape [
	^ $\ asParser2 , (PP2PredicateObjectNode anyOf: (String withAll: CharacterTable keys))
]

{ #category : #primitives }
PPJsonGrammar >> charNormal [
	^ PP2PredicateObjectNode noneOf: '\"'
]

{ #category : #primitives }
PPJsonGrammar >> charOctal [
	^ '\u' asParser2 , (#hex asParser2 min: 4 max: 4)
]

{ #category : #grammar }
PPJsonGrammar >> elements [
	^ value separatedBy: $, asParser2 token trim
]

{ #category : #tokens }
PPJsonGrammar >> falseToken [
	^ 'false' asParser2 token trim
]

{ #category : #grammar }
PPJsonGrammar >> members [
	^ pair separatedBy: $, asParser2 token trim
]

{ #category : #tokens }
PPJsonGrammar >> nullToken [
	^ 'null' asParser2 token trim
]

{ #category : #primitives }
PPJsonGrammar >> number [
	^ $- asParser2 optional ,
		($0 asParser2 / #digit asParser2 plus) ,
		($. asParser2 , #digit asParser2 plus) optional , 
		(($e asParser2 / $E asParser2) , ($- asParser2 / $+ asParser2) optional , #digit asParser2 plus) optional
]

{ #category : #tokens }
PPJsonGrammar >> numberToken [
	^ number token trim
]

{ #category : #grammar }
PPJsonGrammar >> object [
	^ ${ asParser2 token trim , members optional , $} asParser2 token trim
]

{ #category : #grammar }
PPJsonGrammar >> pair [
	^ stringToken , $: asParser2 token trim , value
]

{ #category : #accessing }
PPJsonGrammar >> start [
	^ value end
]

{ #category : #primitives }
PPJsonGrammar >> string [
	^ $" asParser2 , char star , $" asParser2
]

{ #category : #tokens }
PPJsonGrammar >> stringToken [
	^ string token trim
]

{ #category : #tokens }
PPJsonGrammar >> trueToken [
	^ 'true' asParser2 token trim
]

{ #category : #grammar }
PPJsonGrammar >> value [
	^ stringToken / numberToken / object / array / trueToken / falseToken / nullToken
]
