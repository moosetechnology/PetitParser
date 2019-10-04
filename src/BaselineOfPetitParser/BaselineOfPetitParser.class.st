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
		do: [ self defineGlamourDependencyOn: spec.
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
				package: 'PetitIndent' with: [ spec requires: #('Minimal') ];
				package: 'PetitIndent-Examples' with: [ spec requires: #('PetitIndent') ];
				package: 'PetitIndent-Tests' with: [ spec requires: #('Core' 'PetitIndent-Examples') ];
				package: 'PetitParser-Highlighter' with: [ spec requires: #('Minimal' 'PetitAnalyzer') ];
				package: 'PetitParser-Extension' with: [ spec requires: 'PetitParser' ];
				package: 'PetitTests-Extension' with: [ spec requires: 'PetitTests' ];
				package: 'PetitParser-GTExtensions' with: [ spec requires: #('PetitParser' 'PetitIslands' 'PetitParser-Examples') ];
				package: 'PetitGui' with: [ spec requires: #('Glamour' 'Roassal2' 'PetitAnalyzer' 'PetitParser-GTExtensions') ].

			"This methods adds spec for all Grammars available in this repository."
			self defineGrammarsOn: spec.

			spec
				group: 'Minimal' with: #('PetitParser' 'PetitParser-Deprecated');
				group: 'Core' with: #('Minimal' 'PetitTests');
				group: 'Tests' with: #('Core' 'PetitParser-Tests');
				group: 'Examples' with: #('Core' 'PetitParser-Examples');
				group: 'Islands' with: #('PetitIslands' 'PetitIslands-Examples' 'PetitIslands-Tests');
				group: 'Analyzer' with: #('Core' 'PetitAnalyzer' 'PetitAnalyzer-Tests');
				group: 'Indent' with: #('PetitIndent' 'PetitIndent-Tests' 'PetitIndent-Examples');
				group: 'Preprocessor' with: #('PetitPreprocessor' 'PetitPreprocessor-Tests');
				group: 'GT' with: #('Core' 'PetitParser-GTExtensions');
				group: 'Extension' with: #('PetitParser-Extension');
				group: 'TestsExtension' with: #('PetitTests-Extension');
				group: 'Highlighter' with: #('PetitParser-Highlighter');
				group: 'ParserIDE' with: #('PetitGui');
				group: 'SmalltalkCore' with: #('PetitSmalltalk');
				group: 'Smalltalk' with: #('SmalltalkCore' 'PetitSmalltalk-Tests');
				group: 'RegexCore' with: #('PetitRegex');
				group: 'Regex' with: #('RegexCore' 'PetitRegex-Tests');
				group: 'XmlCore' with: #('PetitXml');
				group: 'Xml' with: #('XmlCore' 'PetitXml-Tests');
				group: 'YAMLCore' with: #('PetitYAML');
				group: 'YAML' with: #('YAMLCore' 'PetitYAML-Tests');
				group: 'ParserCore'
					with:
					#('PetitSmalltalk' 'PetitCSV' 'PetitJson' 'PetitMSE' 'PetitManifestMf' 'PetitRegex' 'PetitXPath' 'PetitXml' 'FactorialLanguage' 'PetitYAML');
				group: 'Parser'
					with:
					#('PetitSmalltalk-Tests' 'PetitCSV-Tests' 'PetitJson-Tests' 'PetitMSE-Tests' 'PetitManifestMf-Tests' 'PetitRegex-Tests' 'PetitXPath-Tests' 'PetitXml-Tests' 'FactorialLanguage-Tests' 'PetitYAML-Tests');
				"Override default group to NOT include ParserIDE."
					group: 'default' with: #('Core' 'Tests' 'Examples' 'Islands' 'Analyzer' 'Preprocessor' 'Indent' 'Extension' 'TestsExtension' 'GT' 'Parser') ]
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
		package: 'PetitSmalltalk' with: [ spec requires: #('Minimal') ];
		package: 'PetitSmalltalk-Tests' with: [ spec requires: #('Core' 'PetitSmalltalk') ];
		package: 'PetitCSV' with: [ spec requires: #('Core') ];
		package: 'PetitCSV-Tests' with: [ spec requires: #('Core' 'PetitCSV') ];
		package: 'PetitJson' with: [ spec requires: #('Minimal') ];
		package: 'PetitJson-Tests' with: [ spec requires: #('Core' 'PetitJson') ];
		package: 'PetitMSE' with: [ spec requires: #('Minimal') ];
		package: 'PetitMSE-Tests' with: [ spec requires: #('Core' 'PetitMSE') ];
		package: 'PetitManifestMf' with: [ spec requires: #('Minimal') ];
		package: 'PetitManifestMf-Tests' with: [ spec requires: #('Core' 'PetitManifestMf') ];
		package: 'PetitRegex' with: [ spec requires: #('Minimal') ];
		package: 'PetitRegex-Tests' with: [ spec requires: #('Core' 'PetitRegex') ];
		package: 'PetitXml' with: [ spec requires: #('Minimal') ];
		package: 'PetitXml-Tests' with: [ spec requires: #('Core' 'PetitXml') ];
		package: 'PetitXPath' with: [ spec requires: #('Minimal' 'PetitXml') ];
		package: 'PetitXPath-Tests' with: [ spec requires: #('PetitXPath') ];
		package: 'FactorialLanguage' with: [ spec requires: #('Minimal') ];
		package: 'FactorialLanguage-Tests' with: [ spec requires: #('Core' 'FactorialLanguage') ];
		package: 'PetitYAML' with: [ spec requires: #('Minimal' 'PetitIndent') ];
		package: 'PetitYAML-Tests' with: [ spec requires: #('Core' 'PetitYAML') ]
]

{ #category : #baselines }
BaselineOfPetitParser >> defineRoassalDependencyOn: spec [
	spec
		baseline: 'Roassal2'
		with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ]
]
