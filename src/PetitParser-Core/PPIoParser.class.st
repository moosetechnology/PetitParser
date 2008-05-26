Class {
	#name : #PPIoParser,
	#superclass : #PPCompositeParser,
	#instVars : [
		'expression',
		'message',
		'arguments',
		'symbol',
		'terminator',
		'newline',
		'semicolon',
		'open',
		'close',
		'comma',
		'identifier',
		'number',
		'string'
	],
	#category : #'PetitParser-Builder'
}

{ #category : #grammar }
PPIoParser >> arguments [
	^ open , (expression separatedBy: comma) , close
]

{ #category : #token }
PPIoParser >> close [
	^ $) asParser flatten
]

{ #category : #token }
PPIoParser >> comma [
	^ $, asParser flatten
]

{ #category : #grammar }
PPIoParser >> expression [
	^ message delimitedBy: terminator star
]

{ #category : #token }
PPIoParser >> identifier [
	^ (#letter asParser , #word asParser star) flatten
]

{ #category : #grammar }
PPIoParser >> message [
	^ symbol , arguments optional
]

{ #category : #token }
PPIoParser >> newline [
	^ Character cr asParser flatten
]

{ #category : #token }
PPIoParser >> number [
	^ ($- asParser optional , #digit asParser plus , ($. asParser , #digit asParser plus) optional) flatten
]

{ #category : #token }
PPIoParser >> open [
	^ $( asParser flatten
]

{ #category : #token }
PPIoParser >> semicolon [
	^ $; asParser flatten
]

{ #category : #token }
PPIoParser >> string [
	^ ($" asParser , $" asParser not star , $" asParser) flatten
]

{ #category : #grammar }
PPIoParser >> symbol [
	^ identifier | number | string
]

{ #category : #grammar }
PPIoParser >> terminator [
	^ newline | semicolon
]
