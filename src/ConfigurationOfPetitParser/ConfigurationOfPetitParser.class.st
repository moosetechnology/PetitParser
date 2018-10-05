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

{ #category : #catalog }
ConfigurationOfPetitParser class >> catalogContactInfo [
	^ 'info@moosetechnology.org'
]

{ #category : #catalog }
ConfigurationOfPetitParser class >> catalogDescription [
	^ 'PetitParser is a parsing engine. It models grammars and parsers dynamically as objects based on a mechanism inspired from scannnerless parsing, parser combinators, parsing expression grammars and packrat parsers.'
]

{ #category : #catalog }
ConfigurationOfPetitParser class >> catalogKeywords [
	^ #(parser)
	
]

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
ConfigurationOfPetitParser class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadDevelopment [
	(self project version: #development) load
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadPetitParser [
		(self project version: #development) load: 'Parser'
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadPetitParserIDE [
		(self project version: #development) load: 'ParserIDE'
]

{ #category : #loading }
ConfigurationOfPetitParser class >> loadStable [
	(self project version: #stable) load
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
ConfigurationOfPetitParser >> baseline151: spec [ 
	<version: '1.5.1-baseline'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec description: 'petitparser project description that loads the version before the changes regarding integration of the island grammar and context by Jan Kurs'.
		spec repository: 'http://www.smalltalkhub.com/mc/Moose/PetitParser/main'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'];
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
		spec group: 'Core' with: #( 'PetitParser' 'PetitAnalyzer' ).
		spec group: 'Tests' with: #( 'PetitTests' 'PetitAnalyzer' ) ].

	spec for: #( 'squeakCommon' )  do: [
		spec project: 'Glamour' with: [
			spec
				className: 'ConfigurationOfGlamour';
				file: 'ConfigurationOfGlamour';
				version: #development;
				loads: #('GlamourCore');
				repository: 'http://www.smalltalkhub.com/mc/Moose/Glamour/main' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		spec group: 'Gui' with: #( 'PetitGui' ) ]
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
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'];
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
			package: 'PetitIslands' with: [
				spec requires: #('PetitParser') ];
			package: 'PetitIndent' with: [
				spec requires: #('PetitParser') ];
			package: 'Factorial-Language' with: [
				spec requires: #('PetitParser') ].
		spec group: 'Core' with: #( 'PetitParser').
		spec group: 'Tests' with: #( 'PetitTests') ].

	spec for: #( 'squeakCommon' )  do: [
		spec project: 'Glamour' with: [
			spec
				className: 'ConfigurationOfGlamour';
				file: 'ConfigurationOfGlamour';
				version: #development;
				repository: 'http://www.smalltalkhub.com/mc/Moose/Glamour/main' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		spec group: 'Gui' with: #( 'PetitGui' ) ]
]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline17: spec [ 
	<version: '1.7-baseline'>
	
	spec for: #common do: [
		spec blessing: #'development'.
		spec description: 'Describing all satellite packages. Loads configuration from new repository on SmalltalkHub'.
		spec repository: 'http://www.smalltalkhub.com/mc/Moose/PetitParser/main'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'];
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
			package: 'PetitIndent' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitIslands' with: [
				spec requires: #('PetitParser' 'PetitIndent' 'PetitTests') ];
			package: 'Factorial-Language' with: [
				spec requires: #('PetitParser') ];
			package: 'PetitYAML' with: [
				spec requires: #('PetitParser' 'PetitIndent') ].


		spec group: 'Core' with: #( 'PetitParser').
		spec group: 'Tests' with: #( 'PetitTests').
		spec group: 'Parser' with: #('PetitParser' 
													'PetitTests' 
													'PetitAnalyzer' 
													'PetitSmalltalk' 
													'PetitCSV' 
													'PetitJson' 
													'PetitMSE'
													'PetitManifestMf' 
													'PetitRegex'
													'PetitXPath'
													'PetitXml'
													'PetitIndent'
													'PetitIslands'
													'Factorial-Language'
													'PetitYAML').
	].

	spec for: #( 'squeakCommon' )  do: [
		spec project: 'Glamour' with: [
			spec
				className: 'ConfigurationOfGlamour';
				file: 'ConfigurationOfGlamour';
				version: #stable;
				repository: 'http://www.smalltalkhub.com/mc/Moose/Glamour/main' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		
		spec group: 'ParserIDE' with: #( 'PetitGui' ) ] 
]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline18: spec [ 
	<version: '1.8-baseline'>
	
	spec for: #common do: [
		spec blessing: #'development'.
		spec description: 'For Pharo 5. Use #development for Glamour'.
		spec repository: 'http://www.smalltalkhub.com/mc/Moose/PetitParser/main'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'];
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
			package: 'PetitIndent' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitIslands' with: [
				spec requires: #('PetitParser' 'PetitIndent' 'PetitTests') ];
			package: 'Factorial-Language' with: [
				spec requires: #('PetitParser') ];
			package: 'PetitYAML' with: [
				spec requires: #('PetitParser' 'PetitIndent') ].


		spec group: 'Core' with: #( 'PetitParser').
		spec group: 'Tests' with: #( 'PetitTests').
		spec group: 'Parser' with: #('PetitParser' 
													'PetitTests' 
													'PetitAnalyzer' 
													'PetitSmalltalk' 
													'PetitCSV' 
													'PetitJson' 
													'PetitMSE'
													'PetitManifestMf' 
													'PetitRegex'
													'PetitXPath'
													'PetitXml'
													'PetitIndent'
													'PetitIslands'
													'Factorial-Language'
													'PetitYAML').
	].

	spec for: #( 'squeakCommon' )  do: [
		spec project: 'Glamour' with: [
			spec
				className: 'ConfigurationOfGlamour';
				file: 'ConfigurationOfGlamour';
				version: #development;
				repository: 'http://www.smalltalkhub.com/mc/Moose/Glamour/main' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		
		spec group: 'ParserIDE' with: #( 'PetitGui' ) ] 
]

{ #category : #baselines }
ConfigurationOfPetitParser >> baseline19: spec [ 
	<version: '1.9-baseline'>
	
	spec for: #common do: [
		spec blessing: #'development'.
		spec description: 'For Pharo 6. Use #development for Glamour'.
		spec repository: 'http://www.smalltalkhub.com/mc/Moose/PetitParser/main'.
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'];
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
			package: 'PetitIndent' with: [
				spec requires: #('PetitParser' 'PetitTests') ];
			package: 'PetitIslands' with: [
				spec requires: #('PetitParser' 'PetitIndent' 'PetitTests') ];
			package: 'Factorial-Language' with: [
				spec requires: #('PetitParser') ];
			package: 'PetitYAML' with: [
				spec requires: #('PetitParser' 'PetitIndent') ].


		spec group: 'Core' with: #( 'PetitParser').
		spec group: 'Tests' with: #( 'PetitTests').
		spec group: 'Parser' with: #('PetitParser' 
													'PetitTests' 
													'PetitAnalyzer' 
													'PetitSmalltalk' 
													'PetitCSV' 
													'PetitJson' 
													'PetitMSE'
													'PetitManifestMf' 
													'PetitRegex'
													'PetitXPath'
													'PetitXml'
													'PetitIndent'
													'PetitIslands'
													'Factorial-Language'
													'PetitYAML').
	].

	spec for: #( 'squeakCommon' )  do: [
		spec project: 'Glamour' with: [
			spec
				className: 'ConfigurationOfGlamour';
				file: 'ConfigurationOfGlamour';
				version: #development;
				repository: 'http://www.smalltalkhub.com/mc/Moose/Glamour/main' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		
		spec group: 'ParserIDE' with: #( 'PetitGui' ) ] .
	
	spec
    for: #(#'pharo6.x')
    do: [
		spec
			baseline: 'Glamour' with: [ 
				spec repository: 'github://moosetechnology/Glamour:pharo6/src' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		
		spec group: 'ParserIDE' with: #( 'PetitGui' ) ].
	
	spec
    for: #(#'pharo7.x')
    do: [
		spec
			baseline: 'Glamour' with: [ 
				spec repository: 'github://moosetechnology/Glamour/src' ].
		spec 
			package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer')].
		
		spec group: 'ParserIDE' with: #( 'PetitGui' ) ]

]

{ #category : #'symbolic versions' }
ConfigurationOfPetitParser >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1.8-baseline'.

	spec for: #'pharo1.4.x' version: '1.6-baseline'.

	spec for: #'pharo2.x' version: '1.6-baseline'.

	spec for: #'pharo3.x' version: '1.6-baseline'.

	spec for: #'pharo4.x' version: '1.7-baseline'.

	spec for: #'pharo5.x' version: #'stable'.

	spec for: #'pharo6.x' version: '1.9-baseline'.
	
	spec for: #'pharo7.x' version: '1.9-baseline'.

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

	spec for: #'common' version: '2.0'.

	spec for: #'pharo1.3.x' version: '1.5'.

	spec for: #'pharo2.x' version: '1.6-baseline'.

	spec for: #'pharo3.x' version: '1.10'.

	spec for: #'pharo4.x' version: '1.14'.

	spec for: #'pharo5.x' version: '2.0'.
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
ConfigurationOfPetitParser >> version110: spec [
	<version: '1.10' imports: #('1.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 1.10'.
		spec author: 'TudorGirba'.
		spec timestamp: '12/23/2014 14:30'.
		spec 
			package: 'PetitParser' with: 'PetitParser-JanKurs.262';
			package: 'PetitTests' with: 'PetitTests-JanKurs.67';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-JanKurs.48';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-JanKurs.78';
			package: 'PetitCSV' with: 'PetitCSV-tg.7';
			package: 'PetitJson' with: 'PetitJson-JanKurs.9';
			package: 'PetitMSE' with: 'PetitMSE-AndreHora.21';
			package: 'PetitManifestMf' with: 'PetitManifestMf-JanKurs.10';
			package: 'PetitRegex' with: 'PetitRegex-StephanEggermont.30';
			package: 'PetitXPath' with: 'PetitXPath-EstebanLorenzano.7';
			package: 'PetitXml' with: 'PetitXml-JanKurs.36';
			package: 'PetitIslands' with: 'PetitIslands-JanKurs.18';
			package: 'PetitIndent' with: 'PetitIndent-JanKurs.1';
			package: 'Factorial-Language' with: 'Factorial-Language-lr.6'. ].

	spec for: #'squeakCommon' do: [
		spec project: 'Glamour' with: #stable.
		spec package: 'PetitGui' with: 'PetitGui-JanKurs.148'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version111: spec [
	<version: '1.11' imports: #('1.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 1.11'.
		spec author: 'JanKurs'.
		spec timestamp: '4/1/2015 11:27'.
		spec 
			package: 'PetitParser' with: 'PetitParser-JamesFoster.274';
			package: 'PetitTests' with: 'PetitTests-JanKurs.73';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-JanKurs.48';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-BernardoContreras.86';
			package: 'PetitCSV' with: 'PetitCSV-tg.7';
			package: 'PetitJson' with: 'PetitJson-JanKurs.9';
			package: 'PetitMSE' with: 'PetitMSE-AndreHora.21';
			package: 'PetitManifestMf' with: 'PetitManifestMf-JanKurs.10';
			package: 'PetitRegex' with: 'PetitRegex-StephanEggermont.30';
			package: 'PetitXPath' with: 'PetitXPath-EstebanLorenzano.7';
			package: 'PetitXml' with: 'PetitXml-JanKurs.36';
			package: 'PetitIslands' with: 'PetitIslands-JanKurs.22';
			package: 'PetitIndent' with: 'PetitIndent-JanKurs.7';
			package: 'Factorial-Language' with: 'Factorial-Language-lr.6'. ].

	spec for: #'squeakCommon' do: [
		spec project: 'Glamour' with: #'development'.
		spec package: 'PetitGui' with: 'PetitGui-StefanReichhart.150'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version112: spec [
	<version: '1.12' imports: #('1.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 1.12'.
		spec author: 'AndreiChis'.
		spec timestamp: '5/5/2015 19:03'.
		spec 
			package: 'PetitParser' with: 'PetitParser-JanKurs.278';
			package: 'PetitTests' with: 'PetitTests-JanKurs.73';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-JanKurs.48';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-BernardoContreras.86';
			package: 'PetitCSV' with: 'PetitCSV-tg.7';
			package: 'PetitJson' with: 'PetitJson-JanKurs.9';
			package: 'PetitMSE' with: 'PetitMSE-AndreHora.21';
			package: 'PetitManifestMf' with: 'PetitManifestMf-JanKurs.10';
			package: 'PetitRegex' with: 'PetitRegex-JanKurs.31';
			package: 'PetitXPath' with: 'PetitXPath-EstebanLorenzano.7';
			package: 'PetitXml' with: 'PetitXml-JanKurs.36';
			package: 'PetitIslands' with: 'PetitIslands-JanKurs.28';
			package: 'PetitIndent' with: 'PetitIndent-JanKurs.11';
			package: 'Factorial-Language' with: 'Factorial-Language-lr.6'. ].

	spec for: #'squeakCommon' do: [
		spec project: 'Glamour' with: #'stable'.
		spec package: 'PetitGui' with: 'PetitGui-StefanReichhart.150'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version113: spec [
	<version: '1.13' imports: #('1.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 1.13'.
		spec author: 'AndreiChis'.
		spec timestamp: '5/27/2015 16:41'.
		spec 
			package: 'PetitParser' with: 'PetitParser-JanKurs.278';
			package: 'PetitTests' with: 'PetitTests-JanKurs.73';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-JanKurs.48';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-BernardoContreras.86';
			package: 'PetitCSV' with: 'PetitCSV-tg.7';
			package: 'PetitJson' with: 'PetitJson-JanKurs.9';
			package: 'PetitMSE' with: 'PetitMSE-AndreHora.21';
			package: 'PetitManifestMf' with: 'PetitManifestMf-JanKurs.10';
			package: 'PetitRegex' with: 'PetitRegex-JanKurs.31';
			package: 'PetitXPath' with: 'PetitXPath-EstebanLorenzano.7';
			package: 'PetitXml' with: 'PetitXml-JanKurs.36';
			package: 'PetitIslands' with: 'PetitIslands-JanKurs.28';
			package: 'PetitIndent' with: 'PetitIndent-JanKurs.11';
			package: 'Factorial-Language' with: 'Factorial-Language-lr.6';
			package: 'PetitYAML' with: 'PetitYAML-JanKurs.6'.].

	spec for: #'squeakCommon' do: [
		spec project: 'Glamour' with: #'stable'.
		spec package: 'PetitGui' with: 'PetitGui-StefanReichhart.150'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version114: spec [
	<version: '1.14' imports: #('1.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 1.13'.
		spec author: 'JanKurs'.
		spec timestamp: '20/10/2015 10:41'.
		spec 
			package: 'PetitParser' with: 'PetitParser-JanKurs.278';
			package: 'PetitTests' with: 'PetitTests-JanKurs.73';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-JanKurs.48';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-BernardoContreras.86';
			package: 'PetitCSV' with: 'PetitCSV-tg.7';
			package: 'PetitJson' with: 'PetitJson-JanKurs.9';
			package: 'PetitMSE' with: 'PetitMSE-AndreHora.21';
			package: 'PetitManifestMf' with: 'PetitManifestMf-JanKurs.10';
			package: 'PetitRegex' with: 'PetitRegex-JanKurs.32';
			package: 'PetitXPath' with: 'PetitXPath-EstebanLorenzano.7';
			package: 'PetitXml' with: 'PetitXml-JanKurs.36';
			package: 'PetitIslands' with: 'PetitIslands-JanKurs.32';
			package: 'PetitIndent' with: 'PetitIndent-JanKurs.11';
			package: 'Factorial-Language' with: 'Factorial-Language-lr.6';
			package: 'PetitYAML' with: 'PetitYAML-JanKurs.6'.].

	spec for: #'squeakCommon' do: [
		spec project: 'Glamour' with: #'stable'.
		spec package: 'PetitGui' with: 'PetitGui-StefanReichhart.150'. ].

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
ConfigurationOfPetitParser >> version151: spec [
	<version: '1.5.1' imports: #('1.5.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'releasing a version for petit parser before changes regarding integration of the parsing context and island grammar by Jan Kurs for backward compatibility'.
		spec author: 'usmanbhatti'.
		spec timestamp: '26/9/2014 18:27'.
		spec project: 'Glamour' with: '3.0.7'.
		spec 
			package: 'PetitParser' with: 'PetitParser-DiegoLont.233';
			package: 'PetitTests' with: 'PetitTests-AndreHora.47';
			package: 'PetitXml' with: 'PetitXml-lr.35';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-DiegoLont.46';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-DamienCassou.70';
			package: 'PetitRegex' with: 'PetitRegex-lr.27';
			package: 'PetitGui' with: 'PetitGui-AndreiChis.140'].

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
		spec project: 'Glamour' with: '2.4'.
		spec 
			package: 'PetitParser' with: 'PetitParser-YuriyTymchuk.232';
			package: 'PetitTests' with: 'PetitTests-AndreHora.47';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-DiegoLont.46';
			package: 'PetitGui' with: 'PetitGui-DiegoLont.125'. ].

]

{ #category : #versions }
ConfigurationOfPetitParser >> version19: spec [
	<version: '1.9' imports: #('1.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'releasing a version of petitparser for moose 5 release'.
		spec author: 'StephanEggermont'.
		spec timestamp: '12/12/2014 11:28'.
		spec project: 'Glamour' with: #stable.
		spec 
			package: 'PetitParser' with: 'PetitParser-JanKurs.261';
			package: 'PetitTests' with: 'PetitTests-JanKurs.65';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-JanKurs.48';
			package: 'PetitGui' with: 'PetitGui-TudorGirba.147';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-JanKurs.78';
			package: 'PetitCSV' with: 'PetitCSV-tg.7';
			package: 'PetitJson' with: 'PetitJson-JanKurs.9';
			package: 'PetitMSE' with: 'PetitMSE-AndreHora.21';
			package: 'PetitManifestMf' with: 'PetitManifestMf-JanKurs.10';
			package: 'PetitRegex' with: 'PetitRegex-JanKurs.30';
			package: 'PetitXPath' with: 'PetitXPath-EstebanLorenzano.7';
			package: 'PetitXml' with: 'PetitXml-JanKurs.36';
			package: 'PetitIslands' with: 'PetitIslands-JanKurs.18';
			package: 'PetitIndent' with: 'PetitIndent-JanKurs.1';
			package: 'Factorial-Language' with: 'Factorial-Language-lr.6'. ].
]

{ #category : #versions }
ConfigurationOfPetitParser >> version20: spec [
	<version: '2.0' imports: #('1.8-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'Moose 6.0 release'.
		spec author: 'TudorGirba'.
		spec timestamp: '8/14/2016 20:44'.
		spec 
			package: 'PetitParser' with: 'PetitParser-JanKurs.290';
			package: 'PetitTests' with: 'PetitTests-JanKurs.77';
			package: 'PetitAnalyzer' with: 'PetitAnalyzer-JanKurs.49';
			package: 'PetitSmalltalk' with: 'PetitSmalltalk-TudorGirba.87';
			package: 'PetitCSV' with: 'PetitCSV-tg.7';
			package: 'PetitJson' with: 'PetitJson-JanKurs.9';
			package: 'PetitMSE' with: 'PetitMSE-AndreHora.21';
			package: 'PetitManifestMf' with: 'PetitManifestMf-JanKurs.10';
			package: 'PetitRegex' with: 'PetitRegex-JanKurs.32';
			package: 'PetitXPath' with: 'PetitXPath-EstebanLorenzano.7';
			package: 'PetitXml' with: 'PetitXml-JanKurs.36';
			package: 'PetitIndent' with: 'PetitIndent-JanKurs.25';
			package: 'PetitIslands' with: 'PetitIslands-JanKurs.56';
			package: 'Factorial-Language' with: 'Factorial-Language-lr.6';
			package: 'PetitYAML' with: 'PetitYAML-JanKurs.8'. ].

	spec for: #'squeakCommon' do: [
		spec project: 'Glamour' with: #stable.
		spec package: 'PetitGui' with: 'PetitGui-JanKurs.162'. ].

]
