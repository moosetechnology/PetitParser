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
			spec
				package: 'PetitParser';
				package: 'PetitTests' with: [ spec requires: 'PetitParser' ];
				package: 'PetitParser-Tests' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitParser-Examples' with: [ spec requires: 'PetitParser' ];
				package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests' ];
				package: 'PetitIslands' with: [ spec requires: #('PetitParser' 'PetitIndent' 'PetitTests' 'PetitAnalyzer') ];
				package: 'PetitIslands-Examples' with: [ spec requires: #('PetitIslands') ];
				package: 'PetitIslands-Tests' with: [ spec requires: #('PetitIslands') ];
				package: 'PetitParser-GTExtensions' with: [ spec requires: #('PetitParser' 'PetitIslands' 'PetitParser-Examples') ];
				package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer') ].
			
			"This methods adds spec for all Grammars available in this repository."	
			self defineGrammarsOn: spec.
			
			spec
				group: 'Core' with: #('PetitParser' 'PetitTests');
				group: 'Tests' with: #('Core' 'PetitParser-Tests' );
				group: 'Examples' with: #('Core' 'PetitParser-Examples');
				group: 'GT' with: #('Core' 'PetitParser-GTExtensions');
				group: 'Parser' with: #('PetitParser' 
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
													'PetitIslands-Examples'
													'PetitIslands-Tests'
													'Factorial-Language'
													'PetitYAML');
				group: 'ParserIDE' with: #( 'PetitGui' ).
			spec
				baseline: 'Glamour'
				with: [ spec repository: 'github://moosetechnology/Glamour/src' ] ]
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
		package: 'PetitYAML' with: [ spec requires: #('Core') ]
]
