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
	
	builder newClass composition: traitComposition.
	builder newMetaclass composition: classTraitComposition.

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
	traitedClassSlots := ((superclass isKindOf: TraitedMetaclass) or: [ classSlots anySatisfy: [ :e | e name = #myMethodDict ] ])
		ifTrue: [ #() ]
		ifFalse: [ TraitedMetaclass traitedClassTrait slots  ].

	newMetaclass superclass: superclass withLayoutType: aLayoutType slots: traitedClassSlots, classSlots , classTraitComposition slots
]

{ #category : #migrating }
TraitBuilderEnhancer >> hasToSkipSlot: aSlot [
	^ (Class hasSlotNamed: aSlot name) or: [ TraitedClassTrait hasSlotNamed: aSlot name ]
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
