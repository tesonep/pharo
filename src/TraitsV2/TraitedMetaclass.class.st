Class {
	#name : #TraitedMetaclass,
	#superclass : #Metaclass,
	#instVars : [
		'myMethodDict',
		'composition'
	],
	#category : #TraitsV2
}

{ #category : #accessing }
TraitedMetaclass class >> traitedClassTrait [
	^ (TaCompositionElement for: TraitedClassTrait) -- #methodDict
]

{ #category : #'accessing method dictionary' }
TraitedMetaclass >> addSelectorSilently: selector withMethod: compiledMethod [
	super addSelectorSilently: selector withMethod: compiledMethod.
	self rebuildMethodDictionary.
]

{ #category : #compiling }
TraitedMetaclass >> compile: selector from: oldClass [
	"Compile the method associated with selector in the receiver's method dictionary."

	| method newMethod |
	method := oldClass compiledMethodAt: selector.
	newMethod := self compiler
				source: (oldClass sourceCodeAt: selector);
				class: self;
				failBlock: [^ self];
				compile.   "Assume OK after proceed from SyntaxError"
	selector == newMethod selector ifFalse: [self error: 'selector changed!'].
	self basicAddSelector: selector withMethod: newMethod.
]

{ #category : #accessing }
TraitedMetaclass >> composition: anObject [
	composition := anObject
]

{ #category : #initialization }
TraitedMetaclass >> initialize [
	super initialize.
	myMethodDict := MethodDictionary new.
	composition := {} asTraitComposition.
]

{ #category : #initialization }
TraitedMetaclass >> methodDict [
	^ myMethodDict
]

{ #category : #initialization }
TraitedMetaclass >> methods [
	^ myMethodDict values
]

{ #category : #adding }
TraitedMetaclass >> new [
	| newClass |
	newClass := super new.
	^newClass.
]

{ #category : #initialization }
TraitedMetaclass >> rebuildMethodDictionary [
	| selectors compositionToUse |
	compositionToUse := (superclass isKindOf: self class)
		ifTrue: [ self traitComposition ]
		ifFalse: [ self class traitedClassTrait + self traitComposition ].

	selectors := compositionToUse selectors
		reject: [ :e | myMethodDict keys includes: e ].

	selectors do: [ :e | compositionToUse compile: e into: self ].

	methodDict := myMethodDict copy.

	selectors do: [ :e | myMethodDict removeKey: e ifAbsent: [  ] ]
]

{ #category : #'accessing method dictionary' }
TraitedMetaclass >> removeSelector: aSelector [
	super removeSelector: aSelector.
	self rebuildMethodDictionary.
]

{ #category : #initialization }
TraitedMetaclass >> slots [

	^ super slots reject: [ :e | composition slots includes: e ]
]

{ #category : #accessing }
TraitedMetaclass >> traitComposition [
	^ composition
]

{ #category : #initialization }
TraitedMetaclass >> traits [
	^ composition traits
]
