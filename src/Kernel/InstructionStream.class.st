"
Instance variables:
	sender: <Context|nil> context that invoked this context
	pc: <SmallInteger> (pc = program counter) offset of the bytecode instruction currently executed

My instances can interpret the byte-encoded Smalltalk instruction set. They maintain a program counter (pc) for streaming through CompiledMethods. My subclasses are Contexts, which inherit this capability. They store the return pointer in the instance variable sender, and the current position in their method in the instance variable pc. For other users, sender can hold a method to be similarly interpreted. The unclean re-use of sender to hold the method was to avoid a trivial subclass for the stand-alone scanning function.
"
Class {
	#name : #InstructionStream,
	#superclass : #Object,
	#instVars : [
		'sender',
		'pc'
	],
	#classVars : [
		'SpecialConstants'
	],
	#category : #'Kernel-Methods'
}

{ #category : #'class initialization' }
InstructionStream class >> initialize [
	"Initialize an array of special constants returned by single-bytecode returns."

	SpecialConstants := 
		(Array with: true with: false with: nil)
			, (Array with: -1 with: 0 with: 1 with: 2)	
	"InstructionStream initialize."

]

{ #category : #compiling }
InstructionStream class >> instVarNamesAndOffsetsDo: aBinaryBlock [
	"This is part of the interface between the compiler and a class's instance or field names.
	 We override here to arrange that the compiler will use MaybeContextInstanceVariableNodes
	 for instances variables of Context or any of its superclasses and subclasses.  The
	 convention to make the compiler use the special nodes is to use negative indices"

	| superInstSize |
	(self withAllSubclasses noneSatisfy: [:class|class isContextClass]) ifTrue:
		[^super instVarNamesAndOffsetsDo: aBinaryBlock].
	(superInstSize := superclass notNil ifTrue: [superclass instSize] ifFalse: [0]) > 0 ifTrue:
		[superclass instVarNamesAndOffsetsDo: aBinaryBlock].
	1 to: self instSize - superInstSize do:
		[:i| aBinaryBlock value: (self instVarNames at: i) value: (i + superInstSize) negated]
]

{ #category : #testing }
InstructionStream class >> isContextClass [
	^false
]

{ #category : #'instance creation' }
InstructionStream class >> on: method [ 
	"Answer an instance of me on the argument, method."

	^self new method: method pc: method initialPC
]

{ #category : #scanning }
InstructionStream >> method [
	"Answer the compiled method that supplies the receiver's bytecodes."

	^sender		"method access when used alone (not as part of a context)"
]

{ #category : #private }
InstructionStream >> method: method pc: startpc [

	sender := method. 
	"allows this class to stand alone as a method scanner"
	pc := startpc
]

{ #category : #scanning }
InstructionStream >> pc [
	"Answer the index of the next bytecode."

	^pc
]

{ #category : #private }
InstructionStream >> pc: anInteger [

	pc := anInteger
]
