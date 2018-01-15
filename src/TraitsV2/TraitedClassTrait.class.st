Class {
	#name : #TraitedClassTrait,
	#superclass : #Object,
	#instVars : [
		'methodDict',
		'myMethodDict',
		'composition'
	],
	#category : #TraitsV2
}

{ #category : #adding }
TraitedClassTrait >> addSelectorSilently: selector withMethod: compiledMethod [
	super addSelectorSilently: selector withMethod: compiledMethod.
	self rebuildMethodDictionary.
]

{ #category : #'accessing method dictionary' }
TraitedClassTrait >> allSelectorsBelow: topClass [
	topClass = self
		ifTrue: [ ^ #() ].

	^ (super allSelectorsBelow: topClass) , self traitComposition selectors
]

{ #category : #compiling }
TraitedClassTrait >> compile: selector from: oldClass [
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
TraitedClassTrait >> composition: anObject [
	composition := anObject
]

{ #category : #initialization }
TraitedClassTrait >> initializeTraitedClass [
	myMethodDict := MethodDictionary new.
	composition := TaEmptyComposition new.
	
	self rebuildMethodDictionary.
]

{ #category : #'accessing method dictionary' }
TraitedClassTrait >> methodDict [
	^ myMethodDict 
]

{ #category : #'accessing method dictionary' }
TraitedClassTrait >> methods [
	^ myMethodDict values.
]

{ #category : #initialization }
TraitedClassTrait >> rebuildMethodDictionary [
	| selectors |

	selectors := composition selectors reject: [ :e | myMethodDict keys includes: e ].
	selectors
		do: [ :e | 
			[ composition compile: e into: self ]
				on: NotFound
				do: [ " I ignore if the selector is not anymore in the composition, is a removed method" ] ].

	methodDict := myMethodDict copy.
	selectors do: [ :e | myMethodDict removeKey: e ifAbsent: [  ] ].

	self theMetaClass rebuildMethodDictionary
]

{ #category : #removing }
TraitedClassTrait >> removeSelector: aSelector [
	super removeSelector: aSelector.
	self rebuildMethodDictionary.
]

{ #category : #initialization }
TraitedClassTrait >> slots [
	^ super slots reject:[ :e  | composition slots includes:e ]
]

{ #category : #accessing }
TraitedClassTrait >> traitComposition [
	^ composition
]

{ #category : #accessing }
TraitedClassTrait >> traits [
	^ composition traits.
]
