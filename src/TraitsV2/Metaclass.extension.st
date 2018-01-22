Extension { #name : #Metaclass }

{ #category : #'*TraitsV2' }
Metaclass >> setTraitComposition: aTraitCompositionOrArray [
	
	^ self uses: aTraitCompositionOrArray slots: self slots.
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray [
	
	^ self uses: aTraitCompositionOrArray slots: #().
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray instanceVariableNames: instVarString [ 
	
	^ self uses: aTraitCompositionOrArray slots: instVarString asSlotCollection
]

{ #category : #'*TraitsV2' }
Metaclass >> uses: aTraitCompositionOrArray slots: slotArray [
	| theClass builderEnhancer |
	theClass := self theNonMetaClass.

	(aTraitCompositionOrArray asTraitComposition isEmpty and: [ theClass traitComposition isEmpty ])
		ifTrue: [ ^ self slots: slotArray ].

	builderEnhancer := TraitBuilderEnhancer new.
	builderEnhancer traitComposition: theClass traitComposition asTraitComposition.
	builderEnhancer classTraitComposition: aTraitCompositionOrArray asTraitComposition.

	theClass := theClass classInstaller
		update: theClass
		to: [ :builder | 
			builder
				superclass: theClass superclass;
				builderEnhancer: builderEnhancer;
				metaclassClass: TraitedMetaclass;
				name: theClass name;
				layoutClass: theClass classLayout class;
				slots: theClass slots;
				sharedVariablesFromString: theClass classVariablesString;
				sharedPools: theClass sharedPoolsString;
				traitComposition: theClass traitComposition;
				category: theClass category asString;
				classSlots: slotArray ].
	^ theClass theMetaClass
]
