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
ConfigurationOfPetitParser >> baseline151: spec [ 
	<version: '1.51-baseline'>
	
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
ConfigurationOfPetitParser >> default: spec [ 
	<version: 'default'>
	
	self baseline16: spec.
]

{ #category : #'symbolic versions' }
ConfigurationOfPetitParser >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1.6-baseline'.

	spec for: #'pharo1.4.x' version: '1.6-baseline'.

	spec for: #'pharo2.x' version: '1.6-baseline'.

	spec for: #'pharo3.x' version: '1.6-baseline'.

	spec for: #'pharo4.x' version: '1.6-baseline'.

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

{ #category : #snapshots }
ConfigurationOfPetitParser >> populateSpec: aSpec with: list [
	"generated by Snapshotcello
	
	creates a spec object for the package and the version stored in the list"
	
	list do: [:each |
		aSpec package: each third with: [
			aSpec file: (each first  copyUpToLast: $. ).
			aSpec repository: each second ] ]
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

{ #category : #snapshots }
ConfigurationOfPetitParser >> snapshot1 [
	"generated by Snapshotcello"

	^ #( 
		#('ConfigurationOfGlamour-TudorGirba.117.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'ConfigurationOfGlamour' ) 
		#('PetitParser-YuriyTymchuk.232.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitParser' ) 
		#('PetitTests-AndreHora.47.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitTests' ) 
		#('PetitAnalyzer-DiegoLont.46.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitAnalyzer' ) 
		#('ConfigurationOfRoassal-TudorGirba.1186.mcz'  'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal/main/'  'ConfigurationOfRoassal' ) 
		#('CollectionExtensions-TudorGirba.34.mcz'  'http://www.smalltalkhub.com/mc/Moose/CollectionExtensions/main/'  'CollectionExtensions' ) 
		#('Glamour-Announcements-TudorGirba.7.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Announcements' ) 
		#('Glamour-Helpers-TudorGirba.32.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Helpers' ) 
		#('Glamour-Core-AndreiChis.256.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Core' ) 
		#('Glamour-Presentations-AndreiChis.121.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Presentations' ) 
		#('Glamour-Browsers-AndreiChis.101.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Browsers' ) 
		#('Glamour-Morphic-Widgets-TudorGirba.68.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Morphic-Widgets' ) 
		#('Glamour-Morphic-Renderer-AndreiChis.208.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Morphic-Renderer' ) 
		#('Glamour-Morphic-Theme-TudorGirba.78.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Morphic-Theme' ) 
		#('Glamour-Tools-TudorGirba.66.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Tools' ) 
		#('Glamour-Examples-TudorGirba.262.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Examples' ) 
		#('Roassal-AlexandreBergel.668.mcz'  'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal/main/'  'Roassal' ) 
		#('RoassalMorphic-AlexandreBergel.146.mcz'  'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal/main/'  'RoassalMorphic' ) 
		#('Glamour-Roassal-Presentations-TudorGirba.14.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Roassal-Presentations' ) 
		#('PetitGui-DiegoLont.125.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitGui' ) 
	)
]

{ #category : #snapshots }
ConfigurationOfPetitParser >> snapshot2 [
	"generated by Snapshotcello"

	^ #( 
		#('ConfigurationOfGlamour-TudorGirba.122.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'ConfigurationOfGlamour' ) 
		#('PetitParser-YuriyTymchuk.232.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitParser' ) 
		#('PetitTests-AndreHora.47.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitTests' ) 
		#('PetitAnalyzer-DiegoLont.46.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitAnalyzer' ) 
		#('ConfigurationOfRoassal-AlexandreBergel.1190.mcz'  'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal/main/'  'ConfigurationOfRoassal' ) 
		#('Glamour-Announcements-TudorGirba.7.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Announcements' ) 
		#('Glamour-Helpers-TudorGirba.34.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Helpers' ) 
		#('Glamour-Core-TudorGirba.258.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Core' ) 
		#('Glamour-Presentations-AndreiChis.121.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Presentations' ) 
		#('Glamour-Browsers-DiegoLont.103.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Browsers' ) 
		#('Glamour-Morphic-Widgets-TudorGirba.69.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Morphic-Widgets' ) 
		#('Glamour-Morphic-Renderer-TudorGirba.211.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Morphic-Renderer' ) 
		#('Glamour-Morphic-Theme-TudorGirba.79.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Morphic-Theme' ) 
		#('Roassal-AlexandreBergel.702.mcz'  'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal/main/'  'Roassal' ) 
		#('RoassalMorphic-AlexandreBergel.165.mcz'  'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal/main/'  'RoassalMorphic' ) 
		#('RoassalExtras-RobertoMinelli.26.mcz'  'http://www.smalltalkhub.com/mc/ObjectProfile/Roassal/main/'  'RoassalExtras' ) 
		#('Glamour-Roassal-Presentations-TudorGirba.15.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Roassal-Presentations' ) 
		#('CollectionExtensions-TudorGirba.34.mcz'  'http://www.smalltalkhub.com/mc/Moose/CollectionExtensions/main/'  'CollectionExtensions' ) 
		#('Glamour-Tools-TudorGirba.66.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Tools' ) 
		#('Glamour-Examples-TudorGirba.267.mcz'  'http://www.smalltalkhub.com/mc/Moose/Glamour/main/'  'Glamour-Examples' ) 
		#('PetitGui-DiegoLont.125.mcz'  'http://www.smalltalkhub.com/mc/Moose/PetitParser/main/'  'PetitGui' ) 
	)
]

{ #category : #'symbolic versions' }
ConfigurationOfPetitParser >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.10'.

	spec for: #'pharo1.3.x' version: '1.5'.

	spec for: #'pharo2.x' version: '1.8-snapshot'.

	spec for: #'pharo3.x' version: '1.10'.

	spec for: #'pharo4.x' version: '1.10'.

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
	<version: '1.51' imports: #('1.51-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: 'releasing a version for petit parser before changes regarding integration of the parsing context and island grammar by Jan Kurs for backward compatibility'.
		spec author: 'usmanbhatti'.
		spec timestamp: '26/9/2014 18:27'.
		spec project: 'Glamour' with: #stable.
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

{ #category : #'snapshot versions' }
ConfigurationOfPetitParser >> version17snapshot: spec [
	"generated by Snapshotcello"
	<version: '1.7-snapshot'>

	spec for: #common do: [
		self populateSpec: spec with: self snapshot1.
		spec group: 'Core' with: #( 'PetitParser' 'PetitAnalyzer' ).
		spec group: 'Tests' with: #( 'PetitTests' 'PetitAnalyzer' ) ]
]

{ #category : #'snapshot versions' }
ConfigurationOfPetitParser >> version18snapshot: spec [
	"generated by Snapshotcello"
	<version: '1.8-snapshot'>

	spec for: #common do: [
		spec 
			package: 'PetitParser';
			package: 'PetitTests' with: [ spec requires: 'PetitParser'];
			package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests'].
		self populateSpec: spec with: self snapshot2.
		spec group: 'Core' with: #( 'PetitParser' 'PetitAnalyzer' ).
		spec group: 'Tests' with: #( 'PetitTests' 'PetitAnalyzer' ) ]
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
