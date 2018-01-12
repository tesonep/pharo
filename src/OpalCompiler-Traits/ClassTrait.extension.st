Extension { #name : #ClassTrait }

{ #category : #'*OpalCompiler-Traits' }
ClassTrait >> compiler [
	"The compiler is defined on instance-side to be able to customize it for *one* metaclass"
	^ self instanceSide classSideCompiler
]

{ #category : #'*OpalCompiler-Traits' }
ClassTrait >> compilerClass [
	"The compiler class is defined on instance-side to be able to customize it for *one* metaclass"
	^ self instanceSide classSideCompilerClass
]
