Class {
	#name : #PPListsParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'list',
		'item',
		'indent',
		'dedent',
		'numbering',
		'spaces',
		'text',
		'sublist',
		'line'
	],
	#category : #'PetitIndent-Examples'
}

{ #category : #'as yet unclassified' }
PPListsParser >> dedent [
	^ #dedent asParser
]

{ #category : #'as yet unclassified' }
PPListsParser >> indent [
	^ #indent asParser
]

{ #category : #'as yet unclassified' }
PPListsParser >> item [
	^ (numbering, spaces, text, sublist optional) ==> [ :args | OrderedCollection with: args third with: args fourth ]
]

{ #category : #'as yet unclassified' }
PPListsParser >> line [
	^ ((#letter asParser, #word asParser star) flatten) trimBlanks plus flatten
]

{ #category : #'as yet unclassified' }
PPListsParser >> list [
	^ item plus aligned
]

{ #category : #'as yet unclassified' }
PPListsParser >> numbering [
	^ #digit asParser plus, 
	   ($. asParser, #digit asParser plus) star,
	   $) asParser optional
]

{ #category : #'as yet unclassified' }
PPListsParser >> spaces [
	^ #blank asParser star
]

{ #category : #'as yet unclassified' }
PPListsParser >> start [
	^ list trim end
]

{ #category : #'as yet unclassified' }
PPListsParser >> sublist [
	^ indent, list, dedent ==> #second
]

{ #category : #'as yet unclassified' }
PPListsParser >> text [
	^ line plus aligned ==> [:result | ' ' join: result ]
"	
	firstLine trimBlanks, 
	  ((#newline asParser, line trimBlanks) ==> #second) star 
	  ==> [ :result | result second inject: result first into: [:r :e | r, ' ', e ] ]
"
]
