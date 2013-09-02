"
self loadDevelopment
"
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
	self loadDevelopment
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadDevelopment [
	(self project version: #development) load
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadMinimal [
	(self project version: 'minimal') load
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
ConfigurationOfPetitParser >> baseline11: spec [
	<version: '1.1-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec description: 'Preparing Moose 4.3.2'.
		spec repository: 'http://source.lukas-renggli.ch/petit'.
		spec project: 'Glamour for Petit' with: [
				spec
					className: 'ConfigurationOfGlamour';
					versionString: '2.1';
					repository: 'http://www.squeaksource.com/Glamour' ].
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [
				spec requires: #('PetitParser' ). ];
			package: 'PetitAnalyzer' with: [
				spec requires: #('PetitTests' ). ];
			package: 'PetitGui' with: [
				spec requires: #('Glamour for Petit' ). ].
		spec 
			group: 'Core' with: #('PetitParser' 'PetitAnalyzer' );
			group: 'Tests' with: #('PetitTests' 'PetitAnalyzer' ). ].

]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline12: spec [
	<version: '1.2-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec description: 'Describing satellite packages'.
		spec repository: 'http://source.lukas-renggli.ch/petit'.
		spec project: 'Glamour for Petit' with: [
			spec
				className: 'ConfigurationOfGlamour';
				versionString: '2.1';
				repository: 'http://www.squeaksource.com/Glamour' ].
		
		spec project: 'AST-Core' with: [
			spec
				repository: 'http://www.squeaksource.com/MetacelloRepository';
				className: 'ConfigurationOfRefactoringBrowser';
				loads: #('AST-Core') ].
		
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [
				spec requires: #('PetitParser' ) ];
			package: 'PetitAnalyzer' with: [
				spec requires: #('PetitTests' ) ];
			package: 'PetitGui' with: [
				spec requires: #('Glamour for Petit' ) ];
			package: 'PetitSmalltalk' with: [
				spec requires: #( 'AST-Core' 'PetitParser' 'PetitTests') ].
			"todo: declare all other packages & dependencies here"
		spec 
			group: 'Core' with: #('PetitParser' 'PetitAnalyzer' );
			group: 'Tests' with: #('PetitTests' 'PetitAnalyzer' ) ]

]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline13: spec [
	<version: '1.3-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec description: 'Describing all satellite packages'.
		spec repository: 'http://source.lukas-renggli.ch/petit'.
		spec project: 'Glamour for Petit' with: [
			spec
				className: 'ConfigurationOfGlamour';
				versionString: '2.1';
				loads: #(Core Morphic);
				repository: 'http://www.squeaksource.com/Glamour' ].
		
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [
				spec requires: #('PetitParser' ). ];
			package: 'PetitAnalyzer' with: [
				spec requires: #('PetitTests' ). ];
			package: 'PetitGui' with: [
				spec requires: #('PetitParser' 'Glamour for Petit' ). ].
		
		spec
			package: 'PrettyPetit'.
		
		spec
			package: 'PetitSmalltalk' with: [
				spec requires: #( 'PetitParser' 'PetitTests') ];
			package: 'PetitCSV' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitJson' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitMSE' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitManifestMf' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitRegex' with: [
				spec requires: #('PetitParser') ];
			package: 'PetitSQL' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitXPath' with: [
				spec requires: #('PetitParser' 'PetitXml') ];
			package: 'PetitXml' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'Factorial-Language' with: [
				spec requires: #('PetitParser') ].
		spec 
			group: 'Core' with: #('PetitParser' 'PetitAnalyzer' );
			group: 'Tests' with: #('PetitTests' 'PetitAnalyzer' ). ].

]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline15: spec [
	<version: '1.5-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec description: 'Describing all satellite packages'.
		spec repository: 'http://source.lukas-renggli.ch/petit'.
		spec project: 'Glamour for Petit' with: [
			spec
				className: 'ConfigurationOfGlamour';
				versionString: #stable;
				loads: #(Core Morphic);
				repository: 'http://www.squeaksource.com/Glamour' ].
		
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [
				spec requires: #('PetitParser' ). ];
			package: 'PetitAnalyzer' with: [
				spec requires: #('PetitTests' ). ];
			package: 'PetitGui' with: [
				spec requires: #('PetitParser' 'Glamour for Petit' ). ].
		
		spec
			package: 'PrettyPetit'.
		
		spec
			package: 'PetitSmalltalk' with: [
				spec requires: #( 'PetitParser' 'PetitTests') ];
			package: 'PetitCSV' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitJson' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitMSE' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitManifestMf' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitRegex' with: [
				spec requires: #('PetitParser') ];
			package: 'PetitXPath' with: [
				spec requires: #('PetitParser' 'PetitXml') ];
			package: 'PetitXml' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'Factorial-Language' with: [
				spec requires: #('PetitParser') ].
		spec 
			group: 'default' with: #('UI' 'Tests');
			group: 'Core' with: #('PetitParser' 'PetitAnalyzer' );
			group: 'UI' with: #('Core' 'PetitGui' );
			group: 'Tests' with: #('Core' 'PetitTests'). ].

]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline16: spec [ 
	<version: '1.6-baseline'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec description: 'Describing all satellite packages. Loads configuration from new repository on SmalltalkHub'.
		spec repository: 'http://www.smalltalkhub.com/mc/Moose/PetitParser/main'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'].
		spec group: 'Core' with: #( 'PetitParser' 'PetitAnalyzer' ).
		spec group: 'Tests' with: #( 'PetitTests' 'PetitAnalyzer' ) ].

	spec for: #( 'squeakCommon' )  do: [
		spec project: 'Glamour' with: [
			spec
				className: 'ConfigurationOfGlamour';
				file: 'ConfigurationOfGlamour';
				version: #development;
				loads: #('Core' 'Morphic' 'Roassal');
				repository: 'http://www.smalltalkhub.com/mc/Moose/Glamour/main' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		spec group: 'Gui' with: #( 'PetitGui' ) ]
]

{ #category : #baselines }
ConfigurationOfPetitParser >> default: spec [ 
	<version: 'default'>
	
	self baseline16: spec.
]

{ #category : #'symbolic versions' }
ConfigurationOfPetitParser >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'pharo1.4.x' version: '1.6-baseline'.
	spec for: #'pharo2.x' version: '1.6-baseline'.
	spec for: #'pharo3.x' version: '1.6-baseline'.
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

{ #category : #'symbolic versions' }
ConfigurationOfPetitParser >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.6'.
	spec for: #'pharo1.3.x' version: '1.5'
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

{ #category : #versions }
ConfigurationOfPetitParser >> version11: spec [
	<version: '1.1' imports: #('1.0-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: 'New version'.
		spec author: 'AlexandreBergel'.
		spec timestamp: '2/18/2011 13:30'.
		spec project: 'Glamour for Petit' with: '2.1'.
		spec 
			package: 'PetitParser' with: 'PetitParser-lr.216';
			package: 'PetitTests' with: 'PetitTests-lr.32';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-lr.37';
			package: 'PetitGui' with: 'PetitGui-TudorGirba.65'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version12: spec [
	<version: '1.2' imports: #('1.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: 'New version'.
		spec author: 'AlexandreBergel'.
		spec timestamp: '2/18/2011 13:56'.
		spec project: 'Glamour for Petit' with: '2.1'.
		spec 
			package: 'PetitParser' with: 'PetitParser-lr.216';
			package: 'PetitTests' with: 'PetitTests-lr.32';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-lr.37';
			package: 'PetitGui' with: 'PetitGui-TudorGirba.65'.  ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version13: spec [
	<version: '1.3' imports: #('1.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: ''.
		spec author: 'AlexandreBergel'.
		spec timestamp: '5/16/2011 16:23'.
		spec project: 'Glamour for Petit' with: '2.1'.
		spec 
			package: 'PetitParser' with: 'PetitParser-lr.216';
			package: 'PetitTests' with: 'PetitTests-lr.32';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-lr.37';
			package: 'PetitGui' with: 'PetitGui-TudorGirba.65'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version14: spec [
	<version: '1.4' imports: #('1.3-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: ''.
		spec author: 'DamienPollet'.
		spec timestamp: '8/11/2011 14:00'.
		spec project: 'Glamour for Petit' with: '2.1'.
		spec 
			package: 'PetitParser' with: 'PetitParser-lr.218';
			package: 'PetitTests' with: 'PetitTests-DamienPollet.35';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-lr.39';
			package: 'PetitGui' with: 'PetitGui-TudorGirba.65';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-lr.47'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version15: spec [
	<version: '1.5' imports: #('1.5-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: ''.
		spec author: 'DamienPollet'.
		spec timestamp: '8/11/2011 14:00'.
		spec project: 'Glamour for Petit' with: '2.2'.
		spec 
			package: 'PetitParser' with: 'PetitParser-lr.228';
			package: 'PetitTests' with: 'PetitTests-lr.43';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-lr.39';
			package: 'PetitGui' with: 'PetitGui-TudorGirba.90';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-lr.57'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version16: spec [
	<version: '1.6' imports: #('1.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'releasing a version of petitparser for moose 4.7 release'.
		spec author: 'usmanbhatti'.
		spec timestamp: '3/1/2013 18:01'.
		spec project: 'Glamour for Petit' with: '2.4'.
		spec 
			package: 'PetitParser' with: 'PetitParser-YuriyTymchuk.232';
			package: 'PetitTests' with: 'PetitTests-AndreHora.47';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-DiegoLont.46';
			package: 'PetitGui' with: 'PetitGui-DiegoLont.125'. ].

]
