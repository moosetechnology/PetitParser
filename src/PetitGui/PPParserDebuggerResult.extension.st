Extension { #name : #PPParserDebuggerResult }

{ #category : #'*petitgui' }
PPParserDebuggerResult >> findStream [
	
	stream ifNil: [ ^ parent findStream ].
	^ stream
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

{ #category : #'*petitgui' }
PPParserDebuggerResult >> sampleIn: composite [

	(composite text)
		title: 'Sample';
		display: [:res | res findStream contents ifNil: [''] ];
		allowNil.
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
