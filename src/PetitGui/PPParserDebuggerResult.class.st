"
This class is meant to be used as a model for running a parser over a given stream.

You create it via parse:with: class side method. For example:
self parse: '1 + 2' with: PPArithmeticParser new.

Instance Variables:
	parser	<PPParser>
	result	<Object>
	children	<OrderedCollection of PPParserDebuggerResult>
	parent	<PPParserDebuggerResult>
"
Class {
	#name : #PPParserDebuggerResult,
	#superclass : #Object,
	#instVars : [
		'parser',
		'result',
		'children',
		'parent',
		'start',
		'end',
		'stream',
		'showChildren'
	],
	#category : #'PetitGui-Core'
}

{ #category : #'instance creation' }
PPParserDebuggerResult class >> parse: aStream with: parser [ 
	| root newParser |
	root := self new.
	newParser := parser transform: [:each |
		each name isNil 
			ifTrue: [ each ]
			ifFalse: [
				each >=> [:stream :continuation | 
					| result child |
					child := PPParserDebuggerResult new 
							parser: each;
							parent: root.
					root := root children add: child.
					child start: stream position + 1.
					result := continuation value.
					child end: stream position.
					root result: result.
					root := root parent.
					result ]]].
	newParser parse: aStream.
	^ root children first
]

{ #category : #accessing }
PPParserDebuggerResult >> children [
	^ children
]

{ #category : #accessing }
PPParserDebuggerResult >> children: anObject [
	children := anObject
]

{ #category : #accessing }
PPParserDebuggerResult >> end [
	^ end
]

{ #category : #accessing }
PPParserDebuggerResult >> end: anObject [
	end := anObject
]

{ #category : #'*petitgui' }
PPParserDebuggerResult >> findStream [
	
	stream ifNil: [ ^ parent findStream ].
	^ stream
]

{ #category : #printing }
PPParserDebuggerResult >> formattedText [
	^ self result isPetitFailure 
		ifTrue: [ Text string: self printString attribute: TextColor gray ]
		ifFalse: [ self printString]
]

{ #category : #'*petitgui' }
PPParserDebuggerResult >> gtDebugView: composite [
	<gtInspectorPresentationOrder: 40>

	| browser |
	browser := 
		composite tabulator.

	browser title: 'Debug View'.
	browser row: #tree;
			  row: #source.
				
	browser transmit 
		from: #tree;
		to: #source port: #selectionInterval;
		transformed: [:debuggingResult | debuggingResult ifNotNil: [
			debuggingResult start to: debuggingResult end]
		].

	browser transmit
		to: #source;
		andShow: [ :a |  self sampleIn: a ].
	
	browser transmit 
		to: #tree;
		andShow: [ :a | self treeViewIn: a ].
		
	browser startOn: self
]

{ #category : #initialization }
PPParserDebuggerResult >> initialize [ 
	children := OrderedCollection new
]

{ #category : #accessing }
PPParserDebuggerResult >> parent [
	^ parent
]

{ #category : #accessing }
PPParserDebuggerResult >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
PPParserDebuggerResult >> parser [
	^ parser
]

{ #category : #accessing }
PPParserDebuggerResult >> parser: anObject [
	parser := anObject
]

{ #category : #printing }
PPParserDebuggerResult >> printOn: aStream [ 
	aStream 
		nextPutAll: self parser displayName;
		nextPutAll: ' - ';   
		nextPutAll: self result printString
]

{ #category : #accessing }
PPParserDebuggerResult >> result [
	^ result
]

{ #category : #accessing }
PPParserDebuggerResult >> result: anObject [
	result := anObject
]

{ #category : #'*petitgui' }
PPParserDebuggerResult >> sampleIn: composite [

	(composite text)
		title: 'Sample';
		display: [:res | res findStream contents ifNil: [''] ];
		allowNil.
]

{ #category : #accessing }
PPParserDebuggerResult >> showChildren [
	showChildren ifNil: [ 
		showChildren := true.
	].

	^ showChildren
]

{ #category : #accessing }
PPParserDebuggerResult >> showChildren: aBoolean [
	showChildren := aBoolean
]

{ #category : #accessing }
PPParserDebuggerResult >> start [
	^ start
]

{ #category : #accessing }
PPParserDebuggerResult >> start: anObject [
	start := anObject
]

{ #category : #'*petitgui' }
PPParserDebuggerResult >> stream [
	
	^ stream
]

{ #category : #'*petitgui' }
PPParserDebuggerResult >> stream: anObject [
	
	stream := anObject
]

{ #category : #'*petitgui' }
PPParserDebuggerResult >> treeViewIn: composite [
	composite tree
		title: 'Execution Traces';
		format: [:resultNode | resultNode formattedText ];
	"	display: [ :res | context resultTraces resultFor: context root ];"
		children: [:resultNode | resultNode showChildren 
											ifTrue: [ resultNode children ] 
											ifFalse: [ #() ] ]. 
]
