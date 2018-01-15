Class {
	#name : #TaAliasMethod,
	#superclass : #TaSingleComposition,
	#instVars : [
		'aliases'
	],
	#category : #'TraitsV2-Compositions'
}

{ #category : #'as yet unclassified' }
TaAliasMethod class >> alias:anArrayOfAssociations to: aTrait [
	^ self new
		aliases: anArrayOfAssociations asDictionary;
		inner: aTrait;
		checkAssociations;
		yourself.
]

{ #category : #'transforming selectors' }
TaAliasMethod >> aliasSelector: aSelector [
	^ (self hasAliasForOld: aSelector)
		ifTrue: [ self newSelectorFor: aSelector ]
		ifFalse: [ inner aliasSelector: aSelector ]
]

{ #category : #accessing }
TaAliasMethod >> aliases [
	^ aliases
]

{ #category : #accessing }
TaAliasMethod >> aliases: anObject [
	aliases := anObject
]

{ #category : #accessing }
TaAliasMethod >> checkAssociations [
	self aliases
		associationsDo: [ :assoc | 
			| old new |
			new := assoc key.
			old := assoc value.
			(inner compiledMethodAt: old) ifNil: [ NotFound signalFor: old ] ]
]

{ #category : #accessing }
TaAliasMethod >> compiledMethodAt: aSelector [
	(self hasAliasForOld: aSelector)
		ifTrue: [ NotFound signalFor: aSelector ].

	^ (self hasAliasForNew: aSelector)
		ifTrue: [ inner compiledMethodAt: (self oldSelectorFor: aSelector) ]
		ifFalse: [ inner compiledMethodAt: aSelector ]
]

{ #category : #copying }
TaAliasMethod >> copyTraitExpression [
	^ self class alias: aliases to: inner

]

{ #category : #testing }
TaAliasMethod >> hasAliasForNew: aSelector [
	^ aliases includesKey: aSelector
]

{ #category : #testing }
TaAliasMethod >> hasAliasForOld: aSelector [
	^ aliases values includes: aSelector
]

{ #category : #'instance creation' }
TaAliasMethod >> newSelectorFor: aSelector [
	^ aliases keyAtValue: aSelector
]

{ #category : #aliasing }
TaAliasMethod >> oldSelectorFor: aSelector [
	^ aliases at: aSelector
]

{ #category : #accessing }
TaAliasMethod >> selectors [
	^ (inner selectors reject:[:e | self hasAliasForOld: e]) , self aliases keys. 
]

{ #category : #accessing }
TaAliasMethod >> sourceCodeAt: aSelector [
	^ (self hasAliasForNew: aSelector)
		ifTrue: [ (inner compiledMethodAt: (self oldSelectorFor: aSelector))
				getSourceReplacingSelectorWith: aSelector ]
		ifFalse: [ super sourceCodeAt: aSelector ]
]

{ #category : #printing }
TaAliasMethod >> traitCompositionExpression [
	
	^ self inner traitCompositionExpression , ' @ ' , aliases associations printString
]
