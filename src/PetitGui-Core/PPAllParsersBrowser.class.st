"
self open
"
Class {
	#name : #PPAllParsersBrowser,
	#superclass : #GLMGlobalBrowserTemplate,
	#category : #'PetitGui-Core'
}

{ #category : #building }
PPAllParsersBrowser >> buildBrowser [
	"self open"
	browser := GLMTabulator new.
	browser title: 'PetitParser Browser'.
	browser 
		row: #classes size: 25;
		row: #parser.
	browser transmit to: #classes; andShow: [:a | 
		self classesIn: a ]. 
	browser transmit to: #parser; from: #classes; andShow: [:a | 
		a custom: PPParserBrowser new browser noTitle ].
	^ browser
]

{ #category : #'private building' }
PPAllParsersBrowser >> classesIn: composite [
	composite dropDownList 
		display: [ :class | class allSubclasses asSortedCollection: [ :a :b | a name < b name ] ]
]

{ #category : #opening }
PPAllParsersBrowser >> entity [
	^ PPCompositeParser
]
