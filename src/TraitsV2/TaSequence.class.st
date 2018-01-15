Class {
	#name : #TaSequence,
	#superclass : #TaAbstractComposition,
	#instVars : [
		'members'
	],
	#category : #'TraitsV2-Compositions'
}

{ #category : #'as yet unclassified' }
TaSequence class >> with: initialValue [
	^ self new 
		addMember: initialValue;
		yourself.
]

{ #category : #'as yet unclassified' }
TaSequence class >> withAll: initialMembers [
	^ self new 
		addAll: initialMembers
		yourself.
]

{ #category : #operations }
TaSequence >> + anotherTalent [
	anotherTalent addToSequence: self.
]

{ #category : #operations }
TaSequence >> , anotherTalent [
	anotherTalent addToSequence: self.
	^ self members size = 1
		ifTrue: [ members anyOne ]
		ifFalse: [ self ]
]

{ #category : #operations }
TaSequence >> = anotherTalent [
	(anotherTalent class isKindOf: self class) ifFalse: [ ^false ].
	^ self members = anotherTalent members
]

{ #category : #adding }
TaSequence >> addAll: aCollection [
	aCollection do:[:e | self addMember: e].
]

{ #category : #adding }
TaSequence >> addMember: anotherTalent [
	self validateDuplications: anotherTalent.
	self validateSlots: anotherTalent.
	self validateMethods: anotherTalent.
	
	members add: anotherTalent
]

{ #category : #operations }
TaSequence >> addToSequence: sequence [
	members do:[:e |sequence addMember: e].
]

{ #category : #users }
TaSequence >> addUser: aClass [ 

	members do: [ :m | m addUser: aClass ]
]

{ #category : #'transforming selectors' }
TaSequence >> aliasSelector: aSelector [
	^ members inject: aSelector into:[:acc :each | each aliasSelector: acc]. 
]

{ #category : #querying }
TaSequence >> allTraits [
	^ members flatCollect: #allTraits
]

{ #category : #operations }
TaSequence >> classComposition [
	^ self class withAll: (members collect:#classComposition)
]

{ #category : #accessing }
TaSequence >> compiledMethodAt: aSelector [
	^(members detect:[:e | e selectors includes: aSelector ]) compiledMethodAt:aSelector.
]

{ #category : #copying }
TaSequence >> copyTraitExpression [
	^ self class withAll: (members collect:#copyTraitExpression)
]

{ #category : #initialization }
TaSequence >> initialize [
	super initialize.
	members := OrderedCollection new.
]

{ #category : #initialization }
TaSequence >> initializeObject: anObject [
	members do: [ :e | e initializeObject: anObject ]
]

{ #category : #operations }
TaSequence >> members [
	^ members
]

{ #category : #accessing }
TaSequence >> methods [
	^ members flatCollect: #methods
]

{ #category : #operations }
TaSequence >> name [
	^ '_' join: (members collect:#name) 
]

{ #category : #users }
TaSequence >> removeUser: aClass [ 
	
	self members do: [ :m | m removeUser: aClass] 
]

{ #category : #accessing }
TaSequence >> selectors [
	^ members flatCollect: #selectors
]

{ #category : #accessing }
TaSequence >> slots [
	^ members flatCollect: #slots
]

{ #category : #accessing }
TaSequence >> sourceCodeAt: selector [
	^ (members detect: [ :e | e selectors includes: selector ]) sourceCodeAt: selector
]

{ #category : #printing }
TaSequence >> traitCompositionExpression [
	self isEmpty
		ifTrue: [ ^ '{}' ].

	^ ({members first traitCompositionExpression} , (members allButFirst
		collect: #traitCompositionExpressionWithParens)) joinUsing: ' + '
]

{ #category : #accessing }
TaSequence >> traitDefining: aSelector [
	^ members detect: [ :e | e selectors includes: aSelector ]
]

{ #category : #querying }
TaSequence >> traits [
	^ members flatCollect: #traits
]

{ #category : #validations }
TaSequence >> validateDuplications: anElement [
	(members noneSatisfy: [ :e | e = anElement ])
		ifFalse:[self error:'Could not include the same talent twice'].
]

{ #category : #validations }
TaSequence >> validateMethods: aTrait [
	| newMethods myMethods|
	myMethods := self methods.
	newMethods := aTrait methods reject: [ :e | myMethods includes: e ].

	(self selectors
		noneSatisfy: [ :e | newMethods anySatisfy: [ :x | x selector = e ] ])
		ifFalse: [ self error: 'The added trait duplicates an existing selector' ]
]

{ #category : #validations }
TaSequence >> validateSlots: anElement [
	self slots
		do: [ :e | 
			anElement slots
				do: [ :other | 
					e name = other name
						ifTrue: [ self error: 'The added talent duplicates an existing slot ' , e name printString ] ] ]
]

{ #category : #operations }
TaSequence >> without: aTalent [
	| newMembers |
	newMembers := members collect:[:e | e without: aTalent] thenSelect:#isNotNil.
	
	newMembers ifEmpty: [ ^ nil ].
	
	^ self class withAll: newMembers.
]
