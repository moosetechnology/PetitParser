Class {
	#name : #PPVerticalParserInspector,
	#superclass : #PPParserInspector,
	#category : #'PetitGui-Core'
}

{ #category : #'private building' }
PPVerticalParserInspector >> browserStructureFor: browser [
	browser
		row: #sample;
		row: #inspectors
]
