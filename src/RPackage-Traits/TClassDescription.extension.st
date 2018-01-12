Extension { #name : #TClassDescription }

{ #category : #'*RPackage-Traits' }
TClassDescription >> compileSilently: code [ 
	"Compile the code and classify the resulting method in the given category, leaving no trail in the system log, nor in any change set, nor in the 'recent submissions' list. This should only be used when you know for sure that the compilation will succeed."

	^ self compileSilently: code classified: 'not defined category' notifying: nil.
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> definedSelectors [
	^ self package definedSelectorsForClass: self
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> extendingPackages [
	"the extending packages of a class are the packages that extend it."
	^ RPackage organizer extendingPackagesOf: self
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> extensionSelectors [
	^ self extendingPackages flatCollect: [ :each | each extensionSelectorsForClass: self ]
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> isDefinedInPackage: aPackage [
	"returns true if aPackage contains the definitino of this class"
	
	^ aPackage includesClass: self.
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> isExtended [

	^ self extendingPackages isEmpty
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> isExtendedInPackage: aPackage [
	"returns true if aPackage defines an extension to this class"
	^ aPackage extendsClass: self.
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> package [
	^ RPackage organizer packageOf: self.	
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> packageFromOrganizer: anOrganizer [
	"returns the package that defines this class"
	^ anOrganizer packageOf: self.
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> packageOrganizer [
	"Returns the organizer of this class"
	^ RPackage organizer 
]

{ #category : #'*RPackage-Traits' }
TClassDescription >> packages [
	"the extending packages of a class are the packages that extend it."
	
	^  self extendingPackages asSet copy add: self package; yourself
]
