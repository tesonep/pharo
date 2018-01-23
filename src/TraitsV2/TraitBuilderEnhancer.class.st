Class {
	#name : #TraitBuilderEnhancer,
	#superclass : #ShDefaultBuilderEnhancer,
	#instVars : [
		'builder'
	],
	#category : #'TraitsV2-Class-Builder'
}

{ #category : #testing }
TraitBuilderEnhancer class >> isApplicableFor: aBuilder [
	
	aBuilder superclassName = #Trait ifTrue: [ ^ true ].
	aBuilder superclass = Trait ifTrue: [ ^ true ].
	
	aBuilder oldClass class class = TraitedMetaclass ifTrue: [ ^ true ].
	aBuilder superclass class class = TraitedMetaclass ifTrue: [ ^ true ].

	aBuilder traitComposition asTraitComposition isEmpty ifFalse: [ ^ true ].
	aBuilder classTraitComposition asTraitComposition isEmpty ifFalse: [ ^ true ].

	^ false
]

{ #category : #migrating }
TraitBuilderEnhancer >> afterMigratingClass: aBuilder installer: anInstaller [
	aBuilder newClass traitComposition addUser: aBuilder newClass.
	aBuilder newMetaclass traitComposition addUser: aBuilder newMetaclass.
	
	aBuilder newClass rebuildMethodDictionary.
]

{ #category : #migrating }
TraitBuilderEnhancer >> beforeMigratingClass: aBuilder installer: anInstaller [
	aBuilder oldClass ifNotNil: [ :x | x traitComposition removeUser: x ].
	aBuilder oldMetaclass ifNotNil: [ :x | x traitComposition removeUser: x ]
]

{ #category : #events }
TraitBuilderEnhancer >> classCreated: aBuilder [
	builder newMetaclass rebuildMethodDictionary.
	builder newClass rebuildMethodDictionary.
	
	builder newClass traitComposition: self traitComposition.
	builder newMetaclass traitComposition: self classTraitComposition.

	builder newClass rebuildMethodDictionary.
	builder newMetaclass rebuildMethodDictionary.

]

{ #category : #accessing }
TraitBuilderEnhancer >> classTraitComposition [
	^ builder classTraitComposition
]

{ #category : #accessing }
TraitBuilderEnhancer >> classTraitCompositionOf: aBuilder [ 
	
	^ aBuilder classTraitComposition 
]

{ #category : #utils }
TraitBuilderEnhancer >> classTraitCompositionOfClass: aClass [ 
	
	^ aClass class traitComposition
]

{ #category : #'class modifications' }
TraitBuilderEnhancer >> compileMethodsFor: aBuilder [
	
	super compileMethodsFor: aBuilder.
	
	aBuilder newClass rebuildMethodDictionary.
]

{ #category : #'class modifications' }
TraitBuilderEnhancer >> configureClass: newClass superclass: superclass withLayoutType: layoutType slots: slots [
	| resultingSlots |
	self validateTraitComposition: self traitComposition ofClass: builder oldClass.

	resultingSlots := self
		eliminateDuplicates: slots , self traitComposition slots
		withSuperclassSlots: superclass allSlots.

	newClass superclass: superclass withLayoutType: layoutType slots: resultingSlots
]

{ #category : #'class modifications' }
TraitBuilderEnhancer >> configureMetaclass: newMetaclass superclass: superclass withLayoutType: aLayoutType slots: classSlots [
	| resultingSlots |
	self validateTraitComposition: self classTraitComposition ofClass: builder oldMetaclass.

	resultingSlots := self
		eliminateDuplicates: classSlots , self classTraitComposition slots
		withSuperclassSlots: superclass allSlots.

	newMetaclass superclass: superclass withLayoutType: aLayoutType slots: resultingSlots
]

{ #category : #utils }
TraitBuilderEnhancer >> eliminateDuplicates: aSlotCollection withSuperclassSlots: superclassSlots [
	| resultingSlots |
	resultingSlots := OrderedCollection new.

	aSlotCollection
		do: [ :e | 
			((resultingSlots noneSatisfy: [ :x | e name = x name ]) and: [ superclassSlots noneSatisfy: [ :x | e name = x name ] ])
				ifTrue: [ resultingSlots add: e ] ].


	^ resultingSlots asArray
]

{ #category : #migrating }
TraitBuilderEnhancer >> hasToSkipSlot: aSlot [
	^ Class hasSlotNamed: aSlot name
]

{ #category : #initialization }
TraitBuilderEnhancer >> initializeBuilder: aBuilder [
	super initializeBuilder: aBuilder.

	builder := aBuilder.

	aBuilder addChangeComparer: TraitCompositionChangedDetector.
	aBuilder addChangeComparer: ClassTraitCompositionChangedDetector.

	aBuilder superclass = Trait
		ifTrue: [ aBuilder metaclassClass: MetaclassForTraits ]
		ifFalse: [ aBuilder metaclassClass: TraitedMetaclass ]
]

{ #category : #accessing }
TraitBuilderEnhancer >> traitComposition [
	^ builder traitComposition
]

{ #category : #accessing }
TraitBuilderEnhancer >> traitCompositionOf: aBuilder [ 
	
	^ aBuilder traitComposition
]

{ #category : #utils }
TraitBuilderEnhancer >> traitCompositionOfClass: aClass [ 
	
	^ aClass traitComposition
]

{ #category : #validating }
TraitBuilderEnhancer >> validateTraitComposition: aTraitComposition ofClass: aClass [ 

	^ (aTraitComposition allTraits includes: aClass) ifTrue: [ self error: 'Cyclic Trait composition' ]
]
