Class {
	#name : #ConfigurationOfPetitParser,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#category : #ConfigurationOfPetitParser
}

{ #category : #private }
ConfigurationOfPetitParser class >> ensureMetacello [
	Smalltalk at: #MetacelloProject ifAbsent: [
		Gofer new
				url: 'http://seaside.gemstone.com/ss/metacello';
				package: 'ConfigurationOfMetacello';
				load.
		(Smalltalk at: #ConfigurationOfMetacello) loadLatestVersion ]
]

{ #category : #'metacello tool support' }
ConfigurationOfPetitParser class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadDefault [
	self project version: 'default'
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadMinimal [
	self project version: 'minimal'
]

{ #category : #accessing }
ConfigurationOfPetitParser class >> project [

	^self new project
]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline10: spec [ 
	<version: '1.0-baseline'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec author: 'Alexandre Bergel'.
		spec description: 'work on Pharo 1.1.1'.
		spec repository: 'http://source.lukas-renggli.ch/petit'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'];
			package: 'PetitGui' with: [ spec requires: 'Glamour for Petit'].
		spec group: 'Core' with: #( 'PetitParser' 'PetitAnalyzer' ).
		spec group: 'Tests' with: #( 'PetitTests' 'PetitAnalyzer' ).
		spec project: 'Glamour for Petit' with: [
				spec
					className: 'ConfigurationOfGlamour';
					file: 'ConfigurationOfGlamour';
					version: '2.0-beta.8';
					repository: 'http://www.squeaksource.com/Glamour' ].
	]
]

{ #category : #baselines }
ConfigurationOfPetitParser >> default: spec [ 
	<version: 'default'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec repository: 'http://source.lukas-renggli.ch/petit'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'];
			package: 'PetitGui' with: [ spec requires: 'Glamour for Petit'].
		spec group: 'Core' with: #( 'PetitParser' 'PetitAnalyzer' ).
		spec group: 'Tests' with: #( 'PetitTests' 'PetitAnalyzer' ).
		spec project: 'Glamour for Petit' with: [
				spec
					className: 'ConfigurationOfGlamour';
					file: 'ConfigurationOfGlamour';
					version: 'default';
					repository: 'http://www.squeaksource.com/Glamour' ].
	]
]

{ #category : #'symbolic versions' }
ConfigurationOfPetitParser >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1.0'.

]

{ #category : #baselines }
ConfigurationOfPetitParser >> minimal: spec [ 
	<version: 'minimal'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec repository: 'http://source.lukas-renggli.ch/petit'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'].
		spec group: 'Core' with: #( 'PetitParser' 'PetitAnalyzer' ).
		spec group: 'Tests' with: #( 'PetitTests' 'PetitAnalyzer' )
	]
]

{ #category : #accessing }
ConfigurationOfPetitParser >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project]
]

{ #category : #versions }
ConfigurationOfPetitParser >> version10: spec [
	<version: '1.0' imports: #('1.0-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'First release'.
		spec author: 'AlexandreBergel'.
		spec timestamp: '12/6/2010 16:11'.
		spec project: 'Glamour for Petit' with: '2.0-beta.8'.
		spec 
			package: 'PetitParser' with: 'PetitParser-lr.208';
			package: 'PetitTests' with: 'PetitTests-TudorGirba.24';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-lr.31';
			package: 'PetitGui' with: 'PetitGui-TudorGirba.58'.].

]
