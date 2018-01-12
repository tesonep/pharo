Extension { #name : #Trait }

{ #category : #'*OpalCompiler-Traits' }
Trait >> classSideCompiler [
	"Redefine this method if you want to customize the compiler for class-side methods"
	^self classSideCompilerClass new
		environment: self classSide environment;
		class: self classSide
]

{ #category : #'*OpalCompiler-Traits' }
Trait >> classSideCompilerClass [ 
	"Redefine this method if you want to customize the compiler class for class-side methods"
	^ Smalltalk compilerClass
]
