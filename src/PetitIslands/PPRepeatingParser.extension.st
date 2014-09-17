Extension { #name : #PPRepeatingParser }

{ #category : #'*petitislands' }
PPRepeatingParser >> followSets: aFollowDictionary firstSets: aFirstDictionary into: aSet [
	| firstSet |
	super followSets: aFollowDictionary firstSets:  aFirstDictionary into: aSet.
	
	firstSet := aFirstDictionary at: self.
	self children do: [:p | (aFollowDictionary at: p) addAll: (firstSet reject: [:each | each isNullable]) ]

	"self children do: [ :p | (aFollowDictionary at: p) addAll: aSet ]"
]

{ #category : #'*petitislands' }
PPRepeatingParser >> nextSets: aNextDictionary into: aSet [
	| tally childSet change |

	change := super nextSets: aNextDictionary  into: aSet.

	childSet := aNextDictionary at: parser.
	tally := aSet size.
	childSet add: parser.
	^ change or: [ tally ~= aSet size ].
]
