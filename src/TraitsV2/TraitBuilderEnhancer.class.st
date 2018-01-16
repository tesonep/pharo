Class {
	#name : #TraitBuilderEnhancer,
	#superclass : #ShDefaultBuilderEnhancer,
	#instVars : [
		'traitComposition',
		'classTraitComposition'
	],
	#category : #'TraitsV2-Class-Builder'
}

{ #category : #accessing }
TraitBuilderEnhancer >> afterMigratingClass: aBuilder installer: anInstaller [
	aBuilder newClass traitComposition addUser: aBuilder newClass.
	aBuilder newMetaclass traitComposition addUser: aBuilder newMetaclass
]

{ #category : #accessing }
TraitBuilderEnhancer >> beforeMigratingClass: aBuilder installer: anInstaller [
	aBuilder oldClass ifNotNil: [ :x | x traitComposition removeUser: x ].
	aBuilder oldMetaclass ifNotNil: [ :x | x traitComposition removeUser: x ]
]

{ #category : #'class modifications' }
TraitBuilderEnhancer >> classCreated: builder [
	builder newMetaclass rebuildMethodDictionary.
	builder newClass initializeTraitedClass.
	
	builder newClass traitComposition: traitComposition.
	builder newMetaclass traitComposition: classTraitComposition.

	builder newClass rebuildMethodDictionary.
	builder newMetaclass rebuildMethodDictionary.

]

{ #category : #accessing }
TraitBuilderEnhancer >> classTraitComposition [
	^ classTraitComposition
]

{ #category : #accessing }
TraitBuilderEnhancer >> classTraitComposition: anObject [
	classTraitComposition := anObject
]

{ #category : #accessing }
TraitBuilderEnhancer >> classTraitCompositionOf: aBuilder [ 
	
	^ classTraitComposition 
]

{ #category : #accessing }
TraitBuilderEnhancer >> classTraitCompositionOfClass: aClass [ 
	
	^ aClass class traitComposition
]

{ #category : #'class modifications' }
TraitBuilderEnhancer >> configureClass: newClass superclass: superclass withLayoutType: layoutType slots: slots [
	newClass
		superclass: superclass
		withLayoutType: layoutType
		slots: slots , traitComposition slots
]

{ #category : #'class modifications' }
TraitBuilderEnhancer >> configureMetaclass: newMetaclass superclass: superclass withLayoutType: aLayoutType slots: classSlots [
	| traitedClassSlots |
	
	traitedClassSlots := (self hasRequiredSlots: classSlots , superclass allSlots)
		ifTrue: [ #() ]
		ifFalse: [ TraitedMetaclass traitedClassTrait slots  ].

	newMetaclass superclass: superclass withLayoutType: aLayoutType slots: traitedClassSlots, classSlots , classTraitComposition slots
]

{ #category : #testing }
TraitBuilderEnhancer >> hasRequiredSlots: classSlots [
	
	^ TraitedMetaclass traitedClassTrait slots allSatisfy: [ :e | classSlots anySatisfy: [ :x | x name = e name ] ]
]

{ #category : #migrating }
TraitBuilderEnhancer >> hasToSkipSlot: aSlot [
	^ (Class hasSlotNamed: aSlot name) or: [ TraitedClass hasSlotNamed: aSlot name ]
]

{ #category : #initialization }
TraitBuilderEnhancer >> initializeBuilder: aBuilder [
	super initializeBuilder: aBuilder.
	
	aBuilder addChangeComparer: TraitCompositionChangedDetector.
	aBuilder addChangeComparer: ClassTraitCompositionChangedDetector.	
]

{ #category : #accessing }
TraitBuilderEnhancer >> traitComposition [
	^ traitComposition
]

{ #category : #accessing }
TraitBuilderEnhancer >> traitComposition: anObject [
	traitComposition := anObject
]

{ #category : #accessing }
TraitBuilderEnhancer >> traitCompositionOf: aBuilder [ 
	
	^ traitComposition
]

{ #category : #accessing }
TraitBuilderEnhancer >> traitCompositionOfClass: aClass [ 
	
	^ aClass traitComposition
]
