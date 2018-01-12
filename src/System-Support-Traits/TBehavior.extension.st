Extension { #name : #TBehavior }

{ #category : #'*System-Support-Traits' }
TBehavior >> allCallsOn [
	"Answer a SortedCollection of all the methods that refer to me by name or as part of an association in a global dict."
	self isAnonymous ifTrue: [ ^#() ].
	^ (self allCallsOnIn: self systemNavigation)
]

{ #category : #'*System-Support-Traits' }
TBehavior >> allCallsOn: aSymbol [
	"Answer a SortedCollection of all the methods that call on aSymbol."

	^ self  systemNavigation allCallsOn: aSymbol from: self .
	
]

{ #category : #'*System-Support-Traits' }
TBehavior >> allCallsOnIn: aSystemNavigation [
	"Answer a SortedCollection of all the methods that refer to me by name or as part of an association in a global dict."

	^ (aSystemNavigation 
		allReferencesTo: (self environment associationAt: self theNonMetaClass name)), 
		(aSystemNavigation allCallsOn: self theNonMetaClass name)	
]

{ #category : #'*System-Support-Traits' }
TBehavior >> allUnsentMessages [
	"Answer an array of all the messages defined by the receiver that are not sent anywhere in the system."

	^ SystemNavigation new allUnsentMessagesIn: self selectors
]

{ #category : #'*System-Support-Traits' }
TBehavior >> isUsed [
	self hasSubclasses ifTrue: [ ^ true ].
	^SystemNavigation new isUsedClass: self
]

{ #category : #'*System-Support-Traits' }
TBehavior >> referencedClasses [
	"Return the set of classes that are directly referenced by my methods"

	^ self methods flatCollectAsSet: #referencedClasses
]
