"
I can detect if there is a change in the class Trait composition.
I will not rest longer!!! I should go to the modular trait library.
"
Class {
	#name : #ClassTraitCompositionChangedDetector,
	#superclass : #TraitCompositionChangedDetector,
	#category : #'TraitsV2-Class-Builder'
}

{ #category : #initialization }
ClassTraitCompositionChangedDetector >> initialize [
	super initialize.
	builderAccessor := [ :e | self enhancer classTraitCompositionOf: e ].
	classAccessor := [ :e | self enhancer classTraitCompositionOfClass: e ]
	
]
