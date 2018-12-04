Extension { #name : #PPContext }

{ #category : #'*PetitParser-GTExtensions' }
PPContext >> gtGlobals: composite [
	<gtInspectorPresentationOrder: 50>
	
	composite table
		title: 'Globals';
		column: 'Key' evaluated: [ :each | each key printString ];
		column: 'Value' evaluated: [ :each | each value printString ];
		display: [ :context |  (context globals ifNil: [ Dictionary new ]) associations ]


]

{ #category : #'*PetitParser-GTExtensions' }
PPContext >> gtIndentStack: composite [
	<gtInspectorPresentationOrder: 40>
	
	
	composite list
		title: 'Indent Stack';
		display: [ :context | context indentStack contents ]

]

{ #category : #'*PetitParser-GTExtensions' }
PPContext >> gtProperties: composite [
	<gtInspectorPresentationOrder: 40>
	
	composite table
		title: 'Properties';
		column: 'Key' evaluated: [ :each | each key printString ];
		column: 'Value' evaluated: [ :each | each value printString ];
		display: [ :context |  (context properties ifNil: [ Dictionary new ]) associations ]


]

{ #category : #'*PetitParser-GTExtensions' }
PPContext >> gtStream: composite [
	<gtInspectorPresentationOrder: 40>
	
	composite text
		title: 'Text';
		display: [ :context | context stream printOn: (WriteStream on: String new) ]

]
