Class {
	#name : #TaSequence,
	#superclass : #TaAbstractComposition,
	#instVars : [
		'members'
	],
	#category : #'TraitsV2-Compositions'
}

{ #category : #'instance creation' }
TaSequence class >> with: initialValue [
	^ self new 
		addMember: initialValue;
		yourself.
]

{ #category : #'instance creation' }
TaSequence class >> withAll: initialMembers [

	initialMembers ifEmpty: [ ^ TaEmptyComposition new ].

	^ self new 
		addAll: initialMembers;
		yourself.
]

{ #category : #operations }
TaSequence >> + anotherTalent [
	^ anotherTalent asTraitComposition addToSequence: self copyTraitExpression.
	
]

{ #category : #operations }
TaSequence >> , anotherTalent [
	^ anotherTalent addToSequence: self copy.

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
TaSequence >> addMember: aTrait [
	self validateDuplications: aTrait.
	self validateSlots: aTrait.
	
	members add: aTrait
]

{ #category : #operations }
TaSequence >> addToSequence: sequence [
	members do:[:e |sequence addMember: e].
	^ sequence

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

{ #category : #testing }
TaSequence >> changesSourceCode: aSelector [
 
	^ self members anySatisfy: [ :e | e changesSourceCode: aSelector ]
]

{ #category : #operations }
TaSequence >> classComposition [
	^ self class withAll: (members collect:#classComposition)
]

{ #category : #accessing }
TaSequence >> compiledMethodAt: aSelector [
	^(members reverse detect:[:e | e selectors includes: aSelector ]) compiledMethodAt:aSelector.
]

{ #category : #copying }
TaSequence >> copyTraitExpression [
	^ self class withAll: (members collect:#copyTraitExpression)
]

{ #category : #copying }
TaSequence >> copyWithoutTrait: aTrait [
	| newMembers |

	newMembers := members collect: [ :e | e copyWithoutTrait: aTrait ] thenReject: #isEmpty.

	^ self class withAll: newMembers
	

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

{ #category : #testing }
TaSequence >> isAliasSelector: aSelector [
 
	^ self members anySatisfy: [ :e | e isAliasSelector: aSelector ]
]

{ #category : #testing }
TaSequence >> isConflictingSelector: aSelector [

	^ (self methods count: [ :e | e selector = aSelector ]) > 1
]

{ #category : #testing }
TaSequence >> isLocalAliasSelector: aSymbol [
	^ members anySatisfy: [ :e | e isLocalAliasSelector: aSymbol ]
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
	(self isConflictingSelector: selector) 
		ifTrue: [ ^ self sourceCodeForConflictFor: selector ].

	^ (members reverse detect: [ :e | e selectors includes: selector ]) sourceCodeAt: selector
]

{ #category : #accessing }
TaSequence >> sourceCodeForConflictFor: selector [

	^ String
		streamContents: [ :s | 
			s
				nextPutAll: selector asMethodPreamble;
				cr;
				tab;
				nextPutAll: 'self traitConflict' ]
]

{ #category : #printing }
TaSequence >> traitCompositionExpression [
	self isEmpty
		ifTrue: [ ^ '{}' ].

	^ (members collect: #traitCompositionExpressionWithParens) joinUsing: ' + '
]

{ #category : #accessing }
TaSequence >> traitDefining: aSelector [
	^ (members detect: [ :e | e selectors includes: aSelector ]) traitDefining: aSelector
]

{ #category : #querying }
TaSequence >> traits [
	^ members flatCollect: #traits
]

{ #category : #validations }
TaSequence >> validateDuplications: anElement [
	(members noneSatisfy: [ :e | e = anElement ])
		ifFalse:[self error:'Could not include the same traits twice'].
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
	self slots do: [ :e | anElement slots do: [ :other | 
					(e name = other name and: [ e ~= other ])
						ifTrue: [ self error: 'The added talent duplicates an existing slot ' , e name printString ] ] ]
]

{ #category : #operations }
TaSequence >> without: aTalent [
	| newMembers |
	newMembers := members collect:[:e | e without: aTalent] thenSelect:#isNotNil.
	
	newMembers ifEmpty: [ ^ nil ].
	
	^ self class withAll: newMembers.
]
