Class {
	#name : #BaselineOfPetitParser,
	#superclass : #BaselineOf,
	#category : #BaselineOfPetitParser
}

{ #category : #baselines }
BaselineOfPetitParser >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			self defineGlamourDependencyOn: spec.
			self defineRoassalDependencyOn: spec.
			
			spec
				package: 'PetitParser';
				package: 'PetitParser-Deprecated' with: [ spec requires: 'PetitParser' ];
				package: 'PetitTests' with: [ spec requires: 'PetitParser' ];
				package: 'PetitParser-Tests' with: [ spec requires: #('Core') ];
				package: 'PetitParser-Examples' with: [ spec requires: 'PetitParser' ];
				package: 'PetitAnalyzer' with: [ spec requires: #('PetitParser') ];
				package: 'PetitAnalyzer-Tests' with: [ spec requires: #('Core' 'PetitParser-Examples') ];
				package: 'PetitIslands' with: [ spec requires: #('Core' 'PetitIndent' 'PetitAnalyzer') ];
				package: 'PetitIslands-Examples' with: [ spec requires: #('PetitIslands') ];
				package: 'PetitIslands-Tests' with: [ spec requires: #('PetitIslands') ];
				package: 'PetitPreprocessor' with: [ spec requires: 'PetitParser' ];
				package: 'PetitPreprocessor-Tests' with: [ spec requires: #('PetitPreprocessor' 'PetitTests') ];
				package: 'PetitParser-Extension' with: [ spec requires: 'PetitParser' ];
				package: 'PetitTests-Extension' with: [ spec requires: 'PetitTests' ];
				package: 'PetitParser-GTExtensions' with: [ spec requires: #('PetitParser' 'PetitIslands' 'PetitParser-Examples') ];
				package: 'PetitGui' with: [ spec requires: #('Glamour' 'Roassal2' 'PetitAnalyzer' 'PetitParser-GTExtensions') ].
			
			"This methods adds spec for all Grammars available in this repository."	
			self defineGrammarsOn: spec.
			
			spec
				group: 'Minimal' with: #('PetitParser' 'PetitParser-Deprecated');
				group: 'Core' with: #('Minimal' 'PetitTests');
				group: 'Tests' with: #('Core' 'PetitParser-Tests' );
				group: 'Examples' with: #('Core' 'PetitParser-Examples');
				group: 'Islands' with: #('PetitIslands' 'PetitIslands-Examples' 'PetitIslands-Tests');
				group: 'Analyzer' with: #('Core' 'PetitAnalyzer');
				group: 'Preprocessor' with: #('PetitPreprocessor' 'PetitPreprocessor-Tests');
				group: 'GT' with: #('Core' 'PetitParser-GTExtensions');
				group: 'Extension' with: #('PetitParser-Extension');
				group: 'TestsExtension' with: #('PetitTests-Extension');
				group: 'ParserIDE' with: #('PetitGui');
				group: 'Parser' with: #('PetitSmalltalk'
												'PetitCSV'
												'PetitJson'
												'PetitMSE'
												'PetitManifestMf'
												'PetitRegex'
												'PetitXPath'
												'PetitXml'
												'PetitIndent'
												'Factorial-Language'
												'PetitYAML');
				"Override default group to NOT include ParserIDE."
				group: 'default' with: #('Core' 'Tests' 'Examples' 'Islands' 'Analyzer' 'PetitPreprocessor' 'Extension' 'TestsExtension' 'GT' 'Parser') ]
]

{ #category : #baselines }
BaselineOfPetitParser >> defineGlamourDependencyOn: spec [
	spec
		baseline: 'Glamour'
		with: [ spec repository: 'github://moosetechnology/Glamour/src' ]
]

{ #category : #baselines }
BaselineOfPetitParser >> defineGrammarsOn: spec [
	"Ideally, those packages should be in separated projects.
	 I put them here so it is easier to do in the future."
	spec
		package: 'PetitSmalltalk' with: [ spec requires: #('Core') ];
		package: 'PetitCSV' with: [ spec requires: #('Core') ];
		package: 'PetitJson' with: [ spec requires: #('Core') ];
		package: 'PetitMSE' with: [ spec requires: #('Core') ];
		package: 'PetitManifestMf' with: [ spec requires: #('Core') ];
		package: 'PetitRegex' with: [ spec requires: #('Core') ];
		package: 'PetitXPath' with: [ spec requires: #('Core' 'PetitXml') ];
		package: 'PetitXml' with: [ spec requires: #('Core') ];
		package: 'PetitIndent' with: [ spec requires: #('Core') ];
		package: 'Factorial-Language' with: [ spec requires: #('Core') ];
		package: 'PetitYAML' with: [ spec requires: #('Core' 'PetitIndent') ]
]

{ #category : #baselines }
BaselineOfPetitParser >> defineRoassalDependencyOn: spec [
	spec
		baseline: 'Roassal2'
		with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ]
]
