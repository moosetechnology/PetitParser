Class {
	#name : #ConfigurationOfPetitSmalltalk,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfPetitSmalltalk
}

{ #category : #'development support' }
ConfigurationOfPetitSmalltalk class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfPetitSmalltalk class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #private }
ConfigurationOfPetitSmalltalk class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfPetitSmalltalk class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfPetitSmalltalk class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfPetitSmalltalk class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfPetitSmalltalk class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfPetitSmalltalk class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfPetitSmalltalk class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfPetitSmalltalk class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfPetitSmalltalk >> baseline01: spec [
	<version: '0.1-baseline'>
	spec
		for: #common
		do: [ 
			spec
				blessing: #baseline;
				repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'.
			spec
				project: 'PetitParser'
				with: [ 
					spec
						className: #ConfigurationOfPetitParser;
						versionString: #development;
						loads: #('Core' 'Tests');
						repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/' ].
			spec package: 'PetitSmalltalk' with: [ spec requires: #('PetitParser') ] ]
]

{ #category : #baselines }
ConfigurationOfPetitSmalltalk >> baseline02: spec [
	<version: '0.2-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/'.
		spec project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'development';
					loads: #('Core' 'Tests' );
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/' ].
		spec package: 'PetitSmalltalk' with: [
				spec requires: #('PetitParser' ). ].
		spec 
			group: 'Core' with: #('PetitSmalltalk' );
			group: 'Tests' with: #('PetitSmalltalk' ). ].

]

{ #category : #accessing }
ConfigurationOfPetitSmalltalk >> customProjectAttributes [
	 "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes"

	^ #().
]

{ #category : #'symbolic versions' }
ConfigurationOfPetitSmalltalk >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'pharo4.x' version: #'stable'.

	spec for: #'pharo5.x' version: #'stable'.

	spec for: #'pharo6.x' version: '0.2-baseline'.

]

{ #category : #accessing }
ConfigurationOfPetitSmalltalk >> project [

	^ project ifNil: [ 
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfPetitSmalltalk >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'pharo3.x' version: '1.1'.

	spec for: #'pharo4.x' version: '1.1'.

	spec for: #'pharo5.x' version: '2.0'.

]

{ #category : #versions }
ConfigurationOfPetitSmalltalk >> version11: spec [
	<version: '1.1' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Stable version for Pharo 3'.
		spec author: 'JanKurs'.
		spec timestamp: '4/4/2015 11:32'.
		spec project: 'PetitParser' with: #'development'.
		spec package: 'PetitSmalltalk' with: 'PetitSmalltalk-JanKurs.79'. ].

]

{ #category : #versions }
ConfigurationOfPetitSmalltalk >> version20: spec [
	<version: '2.0' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Moose 6.0 release'.
		spec author: 'TudorGirba'.
		spec timestamp: '8/14/2016 20:44'.
		spec project: 'PetitParser' with: #'stable'.
		spec package: 'PetitSmalltalk' with: 'PetitSmalltalk-TudorGirba.87'. ].

]
