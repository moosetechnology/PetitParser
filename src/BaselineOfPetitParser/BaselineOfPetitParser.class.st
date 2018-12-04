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
				package: 'PetitAnalyzer' with: [ spec requires: 'PetitTests' ];
				package: 'PetitSmalltalk' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitCSV' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitJson' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitMSE' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitManifestMf' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitRegex' with: [ spec requires: #('PetitParser') ];
				package: 'PetitXPath' with: [ spec requires: #('PetitParser' 'PetitXml') ];
				package: 'PetitXml' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitIndent' with: [ spec requires: #('PetitParser' 'PetitTests') ];
				package: 'PetitIslands' with: [ spec requires: #('PetitParser' 'PetitIndent' 'PetitTests') ];
				package: 'Factorial-Language' with: [ spec requires: #('PetitParser') ];
				package: 'PetitYAML' with: [ spec requires: #('PetitParser' 'PetitIndent') ];
				package: 'PetitGui' with: [ spec requires: #('Glamour' 'PetitAnalyzer') ].
			spec
				group: 'Core' with: #( 'PetitParser');
				group: 'Tests' with: #( 'PetitTests');
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
													'Factorial-Language'
													'PetitYAML');
				group: 'ParserIDE' with: #( 'PetitGui' ).
			spec
				baseline: 'Glamour'
				with: [ spec repository: 'github://moosetechnology/Glamour/src' ] ]
]
