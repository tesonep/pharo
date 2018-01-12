Extension { #name : #TraitDescription }

{ #category : #'*RPackage-Traits' }
TraitDescription >> compileSilently: code [ 
	"Compile the code and classify the resulting method in the given category, leaving no trail in the system log, nor in any change set, nor in the 'recent submissions' list. This should only be used when you know for sure that the compilation will succeed."

	^ self compileSilently: code classified: 'not defined category' notifying: nil.
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> definedSelectors [
	^ self package definedSelectorsForClass: self
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> extendingPackages [
	"the extending packages of a class are the packages that extend it."
	^ RPackage organizer extendingPackagesOf: self
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> extensionSelectors [
	^ self extendingPackages flatCollect: [ :each | each extensionSelectorsForClass: self ]
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> isDefinedInPackage: aPackage [
	"returns true if aPackage contains the definitino of this class"
	
	^ aPackage includesClass: self.
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> isExtended [

	^ self extendingPackages isEmpty
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> isExtendedInPackage: aPackage [
	"returns true if aPackage defines an extension to this class"
	^ aPackage extendsClass: self.
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> package [
	^ RPackage organizer packageOf: self.	
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> packageFromOrganizer: anOrganizer [
	"returns the package that defines this class"
	^ anOrganizer packageOf: self.
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> packageOrganizer [
	"Returns the organizer of this class"
	^ RPackage organizer 
]

{ #category : #'*RPackage-Traits' }
TraitDescription >> packages [
	"the extending packages of a class are the packages that extend it."
	
	^  self extendingPackages asSet copy add: self package; yourself
]
