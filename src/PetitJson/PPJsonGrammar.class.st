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
	^ $[ asPParser token trim , elements optional , $] asPParser token trim
]

{ #category : #primitives }
PPJsonGrammar >> char [
	^ charEscape / charOctal / charNormal
]

{ #category : #primitives }
PPJsonGrammar >> charEscape [
	^ $\ asPParser , (PP2PredicateObjectNode anyOf: (String withAll: CharacterTable keys))
]

{ #category : #primitives }
PPJsonGrammar >> charNormal [
	^ PP2PredicateObjectNode noneOf: '\"'
]

{ #category : #primitives }
PPJsonGrammar >> charOctal [
	^ '\u' asPParser , (#hex asPParser min: 4 max: 4)
]

{ #category : #grammar }
PPJsonGrammar >> elements [
	^ value separatedBy: $, asPParser token trim
]

{ #category : #tokens }
PPJsonGrammar >> falseToken [
	^ 'false' asPParser token trim
]

{ #category : #grammar }
PPJsonGrammar >> members [
	^ pair separatedBy: $, asPParser token trim
]

{ #category : #tokens }
PPJsonGrammar >> nullToken [
	^ 'null' asPParser token trim
]

{ #category : #primitives }
PPJsonGrammar >> number [
	^ $- asPParser optional ,
		($0 asPParser / #digit asPParser plus) ,
		($. asPParser , #digit asPParser plus) optional , 
		(($e asPParser / $E asPParser) , ($- asPParser / $+ asPParser) optional , #digit asPParser plus) optional
]

{ #category : #tokens }
PPJsonGrammar >> numberToken [
	^ number token trim
]

{ #category : #grammar }
PPJsonGrammar >> object [
	^ ${ asPParser token trim , members optional , $} asPParser token trim
]

{ #category : #grammar }
PPJsonGrammar >> pair [
	^ stringToken , $: asPParser token trim , value
]

{ #category : #accessing }
PPJsonGrammar >> start [
	^ value end
]

{ #category : #primitives }
PPJsonGrammar >> string [
	^ $" asPParser , char star , $" asPParser
]

{ #category : #tokens }
PPJsonGrammar >> stringToken [
	^ string token trim
]

{ #category : #tokens }
PPJsonGrammar >> trueToken [
	^ 'true' asPParser token trim
]

{ #category : #grammar }
PPJsonGrammar >> value [
	^ stringToken / numberToken / object / array / trueToken / falseToken / nullToken
]
