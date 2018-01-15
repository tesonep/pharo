"
I can detect if there is a change in the Trait composition.
I will not rest longer!!! I should go to the modular trait library.
"
Class {
	#name : #TraitCompositionChangedDetector,
	#superclass : #ShAbstractClassChangeDetector,
	#category : #'TraitsV2-Class-Builder'
}

{ #category : #accessing }
TraitCompositionChangedDetector >> enhancer [
	^ builder builderEnhancer
]

{ #category : #initialization }
TraitCompositionChangedDetector >> initialize [
	super initialize.
	builderAccessor := [ :e | self enhancer traitCompositionOf: e ].
	classAccessor := [ :e | self enhancer traitCompositionOfClass: e ].
	comparer := [ :a :b |  a = b ]
]
