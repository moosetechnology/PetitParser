Class {
	#name : #PPParserInspector,
	#superclass : #GLMBrowserTemplate,
	#category : #'PetitGui-Core'
}

{ #category : #'as yet unclassified' }
PPParserInspector >> buildBrowser [ 
	"self openOn: PPArithmeticParser new"
	browser := GLMTabulator new.
	browser row: #sample; row: #results.
	browser transmit to: #sample; andShow: [:a | 
		a text 
			display: '';
			selectionPopulate: #selection on: $s entitled: 'Parse (s)' with: [ :presentation :parser |
				| stream output |
				stream := PPBrowserStream on: presentation text asString.
				output := parser parse: stream.
				output isPetitFailure
					ifTrue: [ presentation selectionInterval: (output position + 1 to: output position) ].
				output ]].
	browser transmit from: #sample; to: #results; andShow: [:a | 
		self resultsIn: a ].
	^ browser 
]

{ #category : #'as yet unclassified' }
PPParserInspector >> resultsIn: composite [
	composite 
		text
		title: 'Result';
		display: [:result | result ];
		act: [:text | text entity inspect ] 
			icon: GLMUIThemeExtraIcons glamorousInspect
			entitled: 'Inspect'.

]
