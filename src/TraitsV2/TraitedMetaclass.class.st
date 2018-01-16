Class {
	#name : #TraitedMetaclass,
	#superclass : #Metaclass,
	#instVars : [
		'localMethods',
		'composition'
	],
	#category : #TraitsV2
}

{ #category : #accessing }
TraitedMetaclass class >> traitedClassTrait [
	^ (TaCompositionElement for: TraitedClass) -- #methodDict
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

{ #category : #initialization }
TraitedMetaclass >> initialize [
	super initialize.
	localMethods := MethodDictionary new.
	composition := TaEmptyComposition new.
]

{ #category : #'initialize-release' }
TraitedMetaclass >> instanceVariableNames: instVarString [ 
	"Declare additional named variables for my instance."
	| theClass builderEnhancer |
	theClass := self theNonMetaClass.
		
	builderEnhancer := TraitBuilderEnhancer new.
	builderEnhancer traitComposition: theClass traitComposition asTraitComposition.
	builderEnhancer classTraitComposition: self traitComposition asTraitComposition.	
	
	theClass := theClass classInstaller update: theClass to: [ :builder |
		builder
			superclass: theClass superclass;
			builderEnhancer: builderEnhancer;
			metaclassClass: self class;
			name: theClass name;
			layoutClass: theClass classLayout class;
			slots: theClass slots;
			sharedVariablesFromString: theClass classVariablesString;
			sharedPools: theClass sharedPoolsString;
			traitComposition: theClass traitComposition;
			category: theClass category asString;
			classSlots: instVarString asSlotCollection ].
	^ theClass theMetaClass
]

{ #category : #testing }
TraitedMetaclass >> isRejectedMethod: e [
	^ (localMethods includesKey: e) or: [ (superclass methodDict includesKey: e) and: [ (Class methodDict includesKey: e) not ] ]
]

{ #category : #accessing }
TraitedMetaclass >> localSelectors [
	
	^ localMethods keys
]

{ #category : #adding }
TraitedMetaclass >> new [
	| newClass |
	newClass := super new.
	^newClass.
]

{ #category : #initialization }
TraitedMetaclass >> rebuildMethodDictionary [
	| selectors toUse |

	toUse := (superclass isKindOf: self class)
		ifTrue: [ self traitComposition ]
		ifFalse: [ self traitComposition + self class traitedClassTrait ].

	localMethods := MethodDictionary new.
	methodDict valuesDo: [ :m | (m propertyAt: #sourceTrait) ifNil: [ localMethods at: m selector put: m ]].

	selectors := toUse selectors reject: [ :e | self isRejectedMethod: e ].
	selectors do: [ :e | toUse compile: e into: self ].

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

{ #category : #accessing }
TraitedMetaclass >> traitComposition: aComposition [

	composition := aComposition
]

{ #category : #initialization }
TraitedMetaclass >> traits [
	^ composition traits
]
