Class {
	#name : #BaselineOfTraits,
	#superclass : #BaselineOf,
	#category : #BaselineOfTraits
}

{ #category : #baselines }
BaselineOfTraits >> baseline: spec [
	<baseline>

	spec for: #common do: [

		spec 
			package: 'TraitsV2';
			
			package: 'Kernel-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'AST-Core-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'Collections-Abstract-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'Transcript-Core-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'SUnit-Core-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'CodeImport-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'RPackage-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'OpalCompiler-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'Slot-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'CodeExport-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'System-Sources-Traits' with: [ spec requires: #('TraitsV2') ];
			package: 'System-Support-Traits' with: [ spec requires: #('TraitsV2') ].


		spec group: 'core' with: #('TraitsV2' ).
					
		spec group: 'traits-in-kernel' with: #(
					'Kernel-Traits'
					'AST-Core-Traits'
					'Collections-Abstract-Traits'
					'Transcript-Core-Traits'
					'SUnit-Core-Traits'
					'CodeImport-Traits'
					'RPackage-Traits'
					'OpalCompiler-Traits'
					'Slot-Traits'
					'CodeExport-Traits'
					'System-Sources-Traits'
					'System-Support-Traits' ).
				
		spec group: 'default' with: #(core 'traits-in-kernel'). 
	 ].		

]
