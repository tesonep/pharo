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
			package: 'Traits';
			package: 'Shift-ClassBuilder-OldTraits' with: [ spec requires: #('Traits') ];
			package: 'Traits-Traits' with: [ spec requires: #('Traits-Traits') ];
			
			package: 'Kernel-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'AST-Core-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'Collections-Abstract-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'Transcript-Core-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'SUnit-Core-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'CodeImport-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'RPackage-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'OpalCompiler-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'Slot-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'CodeExport-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'System-Sources-Traits' with: [ spec requires: #('Traits-Traits') ];
			package: 'System-Support-Traits' with: [ spec requires: #('Traits-Traits') ].


		spec group: 'core' with: #(
					'Traits'
					'Shift-ClassBuilder-OldTraits'
					'Traits-Traits' ).
					
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
