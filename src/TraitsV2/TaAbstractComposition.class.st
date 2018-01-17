Class {
	#name : #TaAbstractComposition,
	#superclass : #Object,
	#category : #'TraitsV2-Compositions'
}

{ #category : #operations }
TaAbstractComposition >> + anotherTalent [
	^ (TaSequence with: self) + anotherTalent
]

{ #category : #operations }
TaAbstractComposition >> , anotherTalent [
	^ (TaSequence with: self) , anotherTalent
]

{ #category : #operations }
TaAbstractComposition >> - anArrayOrASymbol [
	| anArray |
	
	anArray := anArrayOrASymbol isArray
		ifTrue: [ anArrayOrASymbol ]
		ifFalse: [ {anArrayOrASymbol} ].
		
	^ TaRemoveMethod remove: anArray to: self
]

{ #category : #operations }
TaAbstractComposition >> -- anSlotName [
	^ TaRemoveSlot named: anSlotName from: self.
]

{ #category : #operations }
TaAbstractComposition >> = anotherTrait [
	^ self shouldBeImplemented
]

{ #category : #operations }
TaAbstractComposition >> >> anAssociation [
	^ TaRenameSlot from:anAssociation key to: anAssociation value on: self.
]

{ #category : #operations }
TaAbstractComposition >> @ anArray [
	^ TaAliasMethod alias:anArray to: self.
]

{ #category : #operations }
TaAbstractComposition >> @= anAssociation [
	"This performs a deep alias, rewriting all the sendings of this message"
	^ TaDeepAliasMethod alias:anAssociation to: self.
]

{ #category : #operations }
TaAbstractComposition >> addToSequence: sequence [
	sequence addMember: self.
	^ sequence
]

{ #category : #'transforming selectors' }
TaAbstractComposition >> aliasSelector: selector [
	^ self shouldBeImplemented
]

{ #category : #querying }
TaAbstractComposition >> allTraits [
	^ self subclassResponsibility 
]

{ #category : #converting }
TaAbstractComposition >> asTraitComposition [
	^ self
]

{ #category : #'transforming selectors' }
TaAbstractComposition >> classComposition [
	^ self subclassResponsibility 
]

{ #category : #operations }
TaAbstractComposition >> compile: aSelector into: aClass [
	"It is probable the aliased method does not exists any more in the trait composition. This situation is checked when creating the trait composition."

	[ aClass compile: aSelector from: self.
	aClass >> aSelector propertyAt: #sourceTrait put: (self traitDefining: aSelector) ]
		on: NotFound
		do: [  ]
]

{ #category : #accessing }
TaAbstractComposition >> compiledMethodAt: aSelector [
	self subclassResponsibility 
]

{ #category : #copying }
TaAbstractComposition >> copyTraitExpression [
	^ self subclassResponsibility 
]

{ #category : #accessing }
TaAbstractComposition >> hasMethod: aSelector [
	[ self compiledMethodAt: aSelector.
	^ true ]
		on: NotFound
		do: [ ^ false ]
]

{ #category : #querying }
TaAbstractComposition >> includesTrait: aTrait [
	^ self allTraits includes: aTrait
]

{ #category : #operations }
TaAbstractComposition >> initializeObject: anObject [
	| selector |
	selector := self initializeSelectorForMe.

	(anObject class allSelectors includes: selector)
		ifTrue: [ selector value: anObject ]
]

{ #category : #initialization }
TaAbstractComposition >> initializeSelectorForMe [
	^ self shouldBeImplemented
]

{ #category : #testing }
TaAbstractComposition >> isEmpty [
	^ false
]

{ #category : #'*TraitsV2' }
TaAbstractComposition >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias I define."
	^ false
]

{ #category : #'accessing methods' }
TaAbstractComposition >> methodAt: aSelector ifAbsent: aBlockClosure [ 

	self methods do: [ :e | e selector = aSelector ifTrue: [ ^ e ] ].
	
	^ aBlockClosure value.
]

{ #category : #accessing }
TaAbstractComposition >> name [
	self subclassResponsibility 
]

{ #category : #printing }
TaAbstractComposition >> printOn: aStream [

	aStream nextPutAll: self traitCompositionExpression
]

{ #category : #accessing }
TaAbstractComposition >> selectors [
	self subclassResponsibility 
]

{ #category : #comparing }
TaAbstractComposition >> semanticallyEquals: another [
	^ self selectors = another selectors and: [ self methods = another methods ]
]

{ #category : #accessing }
TaAbstractComposition >> slots [
	self subclassResponsibility 
]

{ #category : #accessing }
TaAbstractComposition >> sourceCodeAt: selector [
	| method |
	method := self compiledMethodAt: selector.
	^ method selector = selector
		ifTrue: [ method sourceCode ]
		ifFalse: [ method getSourceReplacingSelectorWith: selector ]
]

{ #category : #printing }
TaAbstractComposition >> traitCompositionExpression [

	^ self subclassResponsibility
]

{ #category : #printing }
TaAbstractComposition >> traitCompositionExpressionWithParens [
	^ '(' , self traitCompositionExpression , ')'
]

{ #category : #querying }
TaAbstractComposition >> traitDefining: selector [
	^ self shouldBeImplemented.
]

{ #category : #querying }
TaAbstractComposition >> traitDefining: aSelector ifNone: aBlockClosure [ 
	
	[ ^ self traitDefining: aSelector ] on: NotFound do: [ ^ aBlockClosure value ]
]

{ #category : #querying }
TaAbstractComposition >> traits [
	^ self subclassResponsibility 
]

{ #category : #operations }
TaAbstractComposition >> without: anotherTalent [
	^ self shouldBeImplemented
]
