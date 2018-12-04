Extension { #name : #PPFailure }

{ #category : #'*PetitParser-GTExtensions' }
PPFailure >> debugResult [
	context ifNil: [ ^ nil ].
	context root ifNil: [ ^ nil ].
	
	^ context root enableDebug parse: context stream reset
]

{ #category : #'*PetitParser-GTExtensions' }
PPFailure >> gtDebugView: composite [
	<gtInspectorPresentationOrder: 40>

	| browser |
	browser := 
		composite tabulator.

	browser title: 'Debug View'.
	browser row: #tree;
			  row: #source.
	browser transmit 
		fromOutsideEntityPort; 
		toOutsidePort: #debugResult;
		transformed: [ :failure | failure debugResult  ].
				
	browser transmit 
		from: #tree;
		to: #source port: #selectionInterval;
		transformed: [:debuggingResult |
			debuggingResult ifNotNil: [
			debuggingResult start to: debuggingResult end]
		].

	browser transmit
		fromOutsidePort: #debugResult;
		to: #source;
		andShow: [ :a |  self sampleIn: a ].
	
	browser transmit 
		fromOutsidePort: #debugResult;
		to: #tree;
		andShow: [ :a | self treeViewIn: a ].
		
	browser startOn: self
]

{ #category : #'*PetitParser-GTExtensions' }
PPFailure >> sampleIn: composite [

	(composite text)
		title: 'Sample';
		display: [:res | res findStream contents ifNil: [''] ];
		allowNil.
]

{ #category : #'*PetitParser-GTExtensions' }
PPFailure >> treeViewIn: composite [
	composite tree
		title: 'Execution Traces';
		format: [:resultNode | resultNode formattedText ];
		children: [:resultNode | resultNode children ]. 
]
