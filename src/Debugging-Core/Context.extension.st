Extension { #name : #Context }

{ #category : #'*Debugging-Core' }
Context >> blockReturnConstant: value [ 
	"Simulate the interpreter's action when a ReturnConstantToCaller
	bytecode is 
	encountered in the receiver. This should only happen in a closure
	activation. "
	self assert: closureOrNil isClosure.
	^ self return: value from: self

]

{ #category : #'*Debugging-Core' }
Context >> blockReturnTop [
	"Simulate the interpreter's action when a ReturnTopOfStackToCaller bytecode is 
	 encountered in the receiver.  This should only happen in a closure activation."
	[closureOrNil isClosure] assert.
	^self return: self pop from: self
]

{ #category : #'*Debugging-Core' }
Context >> callChainAnySatisfy: aBlock [

	(aBlock value: self) ifTrue: [ ^ true ].
	self sender ifNil: [ ^ false ].
	^ self sender callChainAnySatisfy: aBlock.
]

{ #category : #'*Debugging-Core' }
Context >> callPrimitive: primNumber [
	| res |
	res := receiver tryPrimitive: primNumber withArgs: self arguments.
	primNumber >= (1 << 15) ifTrue: [ "inlined primitive, cannot fail" ^ self push: res ].  
	"regular primitive. Always at the beginning of methods."
	(self isFailToken: res) ifTrue: [ "keeps interpreting the method" ^ self ].
	self push: res.
	self methodReturnTop
]

{ #category : #'*Debugging-Core' }
Context >> completeCallee: aContext [
	"Simulate the execution of bytecodes until a return to the receiver."
	| context current nextContext |
	context := aContext.
	[ context == current or: [ context hasSender: self ] ]
		whileTrue: [
			current := context.
			nextContext := context quickStep.
			nextContext ifNil: [ self halt ].
			context := nextContext ].
	^ self stepToSendOrReturn
]

{ #category : #'*Debugging-Core' }
Context >> doDup [
	"Simulate the action of a 'duplicate top of stack' bytecode."

	self push: self top
]

{ #category : #'*Debugging-Core' }
Context >> doNop [

	"do nothing"
]

{ #category : #'*Debugging-Core' }
Context >> doPop [
	"Simulate the action of a 'remove top of stack' bytecode."

	self pop
]

{ #category : #'*Debugging-Core' }
Context >> failPrimitiveWith: maybePrimFailToken [
	"The receiver is a freshly-created context on a primitive method.  Skip the callPrimitive:
	 bytecode and store the primitive fail code if there is one and the method consumes it."
	self skipCallPrimitive.
	((self isPrimFailToken: maybePrimFailToken)
	  and: [method encoderClass isStoreAt: pc in: method]) ifTrue:
		[self at: stackp put: maybePrimFailToken last]
]

{ #category : #'*Debugging-Core' }
Context >> jump: distance [ 
	"Simulate the action of a 'unconditional jump' bytecode whose offset is 
	the argument, distance."

	pc := pc + distance
]

{ #category : #'*Debugging-Core' }
Context >> jump: distance if: condition [ 
	"Simulate the action of a 'conditional jump' bytecode whose offset is the 
	argument, distance, and whose condition is the argument, condition."

	| bool |
	bool := self pop.
	(bool == true or: [bool == false]) ifFalse: [
		^self
			send: #mustBeBoolean
			to: bool
			with: {}
			super: false].
	(bool eqv: condition) ifTrue: [self jump: distance]
]

{ #category : #'*Debugging-Core' }
Context >> lookupSymbol: aSymbol [
	| scope var |
	scope := self sourceNodeExecuted scope.
	var := scope lookupVar: aSymbol asString.
	"Local variables"
	(var isKindOf: OCTempVariable) ifTrue: [^ var searchFromContext: self scope: scope].
	"Instance variables"
	(var isKindOf: OCSlotVariable) ifTrue: [^ self receiver instVarNamed: aSymbol].
	"Class variables and globals"
	(var isKindOf: OCLiteralVariable) ifTrue: [ ^ var assoc value ].
	^ nil.
	
]

{ #category : #'*Debugging-Core' }
Context >> methodReturnConstant: value [
	"Simulate the action of a 'return constant' bytecode whose value is the
	 argument, value. This corresponds to a source expression like '^0'."

	^self return: value from: self methodReturnContext
]

{ #category : #'*Debugging-Core' }
Context >> methodReturnReceiver [
	"Simulate the action of a 'return receiver' bytecode. This corresponds to
	 the source expression '^self'."

	^self return: self receiver from: self methodReturnContext
]

{ #category : #'*Debugging-Core' }
Context >> methodReturnTop [
	"Simulate the action of a 'return top of stack' bytecode. This corresponds
	 to source expressions like '^something'."

	^self return: self pop from: self methodReturnContext
]

{ #category : #'*Debugging-Core' }
Context >> namedTempAt: index [
	"Answer the value of the temp at index in the receiver's sequence of tempNames."
	^self debuggerMap namedTempAt: index in: self
]

{ #category : #'*Debugging-Core' }
Context >> namedTempAt: index put: aValue [
	"Set the value of the temp at index in the receiver's sequence of tempNames.
	 (Note that if the value is a copied value it is also set out along the lexical chain,
	  but alas not in along the lexical chain.)."
	^self debuggerMap namedTempAt: index put: aValue in: self
]

{ #category : #'*Debugging-Core' }
Context >> popIntoLiteralVariable: value [ 
	"Simulate the action of bytecode that removes the top of the stack and 
	stores it into a literal variable of my method."

	value value: self pop
]

{ #category : #'*Debugging-Core' }
Context >> popIntoReceiverVariable: offset [ 
	"Simulate the action of bytecode that removes the top of the stack and 
	stores it into an instance variable of my receiver."

	self object: self receiver instVarAt: offset + 1 put: self pop
]

{ #category : #'*Debugging-Core' }
Context >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Simulate the action of bytecode that removes the top of the stack and  stores
	 it into an offset in one of my local variables being used as a remote temp vector."

	(self at: tempVectorIndex + 1) at: remoteTempIndex + 1 put: self pop
]

{ #category : #'*Debugging-Core' }
Context >> popIntoTemporaryVariable: offset [ 
	"Simulate the action of bytecode that removes the top of the stack and 
	stores it into one of my temporary variables."

	self at: offset + 1 put: self pop
]

{ #category : #'*Debugging-Core' }
Context >> pushActiveContext [
	"Simulate the action of bytecode that pushes the the active context on the 
	top of its own stack."

	self push: self
]

{ #category : #'*Debugging-Core' }
Context >> pushActiveProcess [
	"Simulate the action of bytecode that pushes the the active Process on the 
	top of its own stack."

	self push: Processor activeProcess
]

{ #category : #'*Debugging-Core' }
Context >> pushArgs: arguments from: senderContext [
	"Helps simulate action of the value primitive for closures.
	 This is used by Context>>runSimulated:contextAtEachStep:"

	closureOrNil
		ifNil: [self error: 'context needs a closure!']
		ifNotNil: [
			"See BlockClosure>>asContextWithSender:"
			 stackp ~= (closureOrNil numArgs + closureOrNil numCopiedValues) 
				ifTrue: [ self error: 'stack pointer is incorrect!' ]].

	1 to: closureOrNil numArgs do: [:i |
		self at: i put: (arguments at: i)].
	sender := senderContext
]

{ #category : #'*Debugging-Core' }
Context >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [
	"Simulate the action of a 'closure copy' bytecode whose result is the
	 new BlockClosure for the following code"
	| copiedValues |
	numCopied > 0
		ifTrue: [
			copiedValues := Array new: numCopied.
			numCopied to: 1 by: -1 do: [ :i |
				copiedValues at: i put: self pop ]]
		ifFalse: [ copiedValues := nil ].
	self push: (BlockClosure
				outerContext: self
				startpc: pc
				numArgs: numArgs
				copiedValues: copiedValues).
	self jump: blockSize
]

{ #category : #'*Debugging-Core' }
Context >> pushClosureTemps: numTemps [
	numTemps timesRepeat: [ self push: nil ]
]

{ #category : #'*Debugging-Core' }
Context >> pushConsArrayWithElements: numElements [ 
	| array |
	array := Array new: numElements.
	numElements to: 1 by: -1 do: [ :i |
		array at: i put: self pop ].
	self push: array
]

{ #category : #'*Debugging-Core' }
Context >> pushConstant: value [ 
	"Simulate the action of bytecode that pushes the constant, value, on the 
	top of the stack."

	self push: value
]

{ #category : #'*Debugging-Core' }
Context >> pushFullClosure: compiledBlock numCopied: numCopied receiverOnStack: onStack ignoreOuterContext: ignore [
	| copiedValues cls |
	copiedValues := (1 to: numCopied) collect: [ :i | self pop ].
	self push: (cls := (FullBlockClosure new: numCopied) 
		outerContext: (ignore ifFalse: [self]);
		receiver: (onStack ifTrue: [ self pop ] ifFalse: [ receiver ]);
		numArgs: compiledBlock numArgs;
		compiledBlock: compiledBlock;
		yourself).
	copiedValues size to: 1 by: -1 do: [ :i |
		 cls at: copiedValues size - i + 1 put: (copiedValues at: i) ]
]

{ #category : #'*Debugging-Core' }
Context >> pushLiteralVariable: value [ 
	"Simulate the action of bytecode that pushes the contents of the literal 
	variable whose index is the argument, index, on the top of the stack."

	self push: value value
]

{ #category : #'*Debugging-Core' }
Context >> pushNewArrayOfSize: arraySize [ 
	self push: (Array new: arraySize)
]

{ #category : #'*Debugging-Core' }
Context >> pushReceiver [
	"Simulate the action of bytecode that pushes the active context's receiver 
	on the top of the stack."

	self push: self receiver
]

{ #category : #'*Debugging-Core' }
Context >> pushReceiverVariable: offset [ 
	"Simulate the action of bytecode that pushes the contents of the receiver's 
	instance variable whose index is the argument, index, on the top of the 
	stack."

	self push: (self object: self receiver instVarAt: offset + 1)
]

{ #category : #'*Debugging-Core' }
Context >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Simulate the action of bytecode that pushes the value at remoteTempIndex
	 in one of my local variables being used as a remote temp vector."
	self push: ((self at: tempVectorIndex + 1) at: remoteTempIndex + 1)
]

{ #category : #'*Debugging-Core' }
Context >> pushTemporaryVariable: offset [ 
	"Simulate the action of bytecode that pushes the contents of the 
	temporary variable whose index is the argument, index, on the top of 
	the stack."

	self push: (self at: offset + 1)
]

{ #category : #'*Debugging-Core' }
Context >> quickSend: selector to: aReceiver with: arguments super: superFlag [
	"Send the given selector with arguments in an environment which closely resembles the non-simulating environment, with an interjected unwind-protected block to catch nonlocal returns.
	Attention: don't get lost!"
	| lookupClass contextToReturnTo result |
	contextToReturnTo := self.
	lookupClass := superFlag
					ifTrue: [(self method literalAt: self method numLiterals) value superclass]
					ifFalse: [self objectClass: aReceiver].
	[ | oldSender |
	oldSender := thisContext sender swapSender: self.
	result := self object: aReceiver perform: selector withArguments: arguments inClass: lookupClass.
	thisContext sender swapSender: oldSender] ifCurtailed: [
		contextToReturnTo := thisContext sender receiver.	"The block context returning nonlocally"
		contextToReturnTo jump: -1.	"skip to front of return bytecode causing this unwind"
		contextToReturnTo nextByte = 16r7C ifTrue: [
			"If it was a returnTop, push the value to be returned.
			Otherwise the value is implicit in the bytecode"
			contextToReturnTo push: (thisContext sender tempAt: 1)].
		thisContext swapSender: thisContext home sender.	"Make this block return to the method's sender"
		contextToReturnTo].
	contextToReturnTo push: result.
	^contextToReturnTo
]

{ #category : #'*Debugging-Core' }
Context >> quickStep [
	"If the next instruction is a send, just perform it.
	Otherwise, do a normal step."

	self willSend ifTrue: [ QuickStep := self ].
	^self step
]

{ #category : #'*Debugging-Core' }
Context >> respondsToUnknownBytecode [
	"This method is triggerred by the VM when the interpreter tries to execute an unknown bytecode"
	
	| unknownBytecode |
	unknownBytecode := self method at: self pc.
	self error: 'VM cannot run unknown bytecode ', unknownBytecode printString
	

]

{ #category : #'*Debugging-Core' }
Context >> restart [
	"Unwind thisContext to self and resume from beginning.  Execute unwind blocks when unwinding.  ASSUMES self is a sender of thisContext"

	| context unwindBlock |
	self isDead ifTrue: [self cannotReturn: nil to: self].
	self privRefresh.
	context := thisContext.
	[	context := context findNextUnwindContextUpTo: self.
		context isNil 
	] whileFalse: [
		context unwindComplete ifNil:[
			context unwindComplete: true.
			unwindBlock := context unwindBlock.
			thisContext terminateTo: context.
			unwindBlock value ]].
	
	thisContext terminateTo: self.
	self jump.

]

{ #category : #'*Debugging-Core' }
Context >> restartWithNewReceiver: obj [

	self
		swapReceiver: obj;
		restart
]

{ #category : #'*Debugging-Core' }
Context >> return: value to: aSender [
	"Simulate the return of value to aSender."

	self releaseTo: aSender.
	aSender ifNil: [^ nil].
	^ aSender push: value
]

{ #category : #'*Debugging-Core' }
Context class >> runSimulated: aBlock [
	"Simulate the execution of the argument, current. Answer the result it 
	returns."

	^ thisContext sender
		runSimulated: aBlock
		contextAtEachStep: [:ignored |]

	"Context runSimulated: [Pen new defaultNib: 5; go: 100]"
]

{ #category : #'*Debugging-Core' }
Context >> runSimulated: aBlock contextAtEachStep: block2 [
	"Simulate the execution of the argument, aBlock, until it ends. aBlock 
	MUST NOT contain an '^'. Evaluate block2 with the current context 
	prior to each instruction executed. Answer the simulated value of aBlock."
	| current returnContext exception |
	
	aBlock hasMethodReturn
		ifTrue: [ self error: 'simulation of blocks with ^ can run loose' ].
		
	current := [ aBlock
					on: Exception
					do: [ :ex | SimulationExceptionWrapper signalForException: ex  ] ] asContext.
	
	returnContext := Context
			sender: nil
			receiver: self home receiver
			method: self home method
			arguments: self home arguments.
	
	current pushArgs: Array new from: returnContext.
	
	[current == returnContext]
		whileFalse: [ 
			block2 value: current.
			current := current step ].
	
	exception := returnContext pop.
	exception class == SimulationExceptionWrapper
		ifTrue: [ ^ exception exception signal ].
	^ exception
	
]

{ #category : #'*Debugging-Core' }
Context >> send: selector super: superFlag numArgs: numArgs [
	"Simulate the action of bytecodes that send a message with selector, 
	selector. The argument, superFlag, tells whether the receiver of the 
	message was specified with 'super' in the source method. The arguments 
	of the message are found in the top numArgs locations on the stack and 
	the receiver just below them."

	| currentReceiver arguments  |
	arguments := Array new: numArgs.
	numArgs to: 1 by: -1 do: [ :i | 
		arguments at: i put: self pop ].
	currentReceiver := self pop.
"	selector == #doPrimitive:method:receiver:args:
		ifTrue: [answer := receiver 
					doPrimitive: (arguments at: 1)
					method: (arguments at: 2)
					receiver: (arguments at: 3)
					args: (arguments at: 4).
				self push: answer.
				^self]. "
	QuickStep == self ifTrue: [
		QuickStep := nil.
		^ self quickSend: selector to: currentReceiver with: arguments super: superFlag].
	^ self send: selector to: currentReceiver with: arguments super: superFlag
]

{ #category : #'*Debugging-Core' }
Context >> simulatePrimitive: primitiveIndex in: aMethod receiver: aReceiver arguments: arguments [
	| key simulator |
	
	key := primitiveIndex = 117 
		ifTrue: [ | literal |
			literal := aMethod literalAt: 1.
			"primitive name, module name"
			{literal second. literal first}] 
		ifFalse: [ primitiveIndex ].
	
	simulator := self class specialPrimitiveSimulators at: key ifAbsent: [
		 "named primitives"
		^  primitiveIndex = 117
				ifTrue: [
					self withoutPrimitiveTryNamedPrimitiveIn: aMethod for: aReceiver withArgs: arguments.
					"this uses primitive 218, which doesn't works as expected... 
					self tryNamedPrimitiveIn: method for: receiver withArgs: arguments " ]
				ifFalse: [ aReceiver tryPrimitive: primitiveIndex withArgs: arguments ]]. 
	
	^ simulator 
		simulatePrimitiveFor: aMethod
		receiver: aReceiver
		arguments: arguments
		context: self
]

{ #category : #'*Debugging-Core' }
Context class >> simulatePrimitive: primName module: moduleName with: simulator [
	^ self specialPrimitiveSimulators at: {primName. moduleName} put: simulator
]

{ #category : #'*Debugging-Core' }
Context class >> simulatePrimitiveNumber: num with: simulator [
	^ self specialPrimitiveSimulators at: num put: simulator
]

{ #category : #'*Debugging-Core' }
Context >> step [
	"Simulate the execution of the receiver's next bytecode. Answer the 
	context that would be the active context after this bytecode."

	^self interpretNextInstructionFor: self
]

{ #category : #'*Debugging-Core' }
Context >> stepToCallee [
	"Step to callee or sender"

	| context |
	context := self.
	[ (context := context step) == self ] whileTrue.
	^ context
]

{ #category : #'*Debugging-Core' }
Context >> stepToHome: aContext [ 
	"Resume self until the home of top context is aContext.  Top context may be a block context."

	| home ctxt here error topContext context |
	
	here := thisContext.
	ctxt := self step.
	ctxt = self ifFalse: [ 
		"Insert ensure and exception handler contexts under aSender"
		error := nil.
		context := aContext insertSender: (Context
			contextOn: UnhandledError do: [:ex |
				error ifNil: [
					"this is ugly but it fixes the side-effects of not sending an Unhandled error on Halt"
					error := (ex isKindOf: Halt) ifTrue: [ ex ] ifFalse: [ ex exception ].
					topContext := thisContext.
					ex resumeUnchecked: here jump ]
						ifNotNil: [ ex pass ]]).
	].
	home := aContext home.
	home == ctxt home ifTrue: [ ^{ctxt. nil} ].
	
	[ctxt := ctxt step.
	error ifNotNil: [
		"Error was raised, remove inserted above contexts then return signaler context"
			"aContext terminateTo: context sender."  "remove above ensure and handler contexts"
			^ {ctxt. error}].
	
	home == ctxt home] whileFalse: [
		home isDead ifTrue: [^ {ctxt. nil}]
	].

	^ {ctxt. nil}
]

{ #category : #'*Debugging-Core' }
Context >> stepToSendOrReturn [
	"Simulate the execution of bytecodes until either sending a message or 
	returning a value to the receiver (that is, until switching contexts)."

	| context |
	[ self willSend or: [  self willReturn or: [ self willStore or: [self willCreateBlock ] ] ] ]
		whileFalse: [
			self isDead ifTrue: [ ^ self ].
			context := self step.
			context == self ifFalse: [
				"Caused by mustBeBoolean handling"
				^context ]]
]

{ #category : #'*Debugging-Core' }
Context >> storeIntoLiteralVariable: value [ 
	"Simulate the action of bytecode that stores the top of the stack into a 
	literal variable of my method."

	value value: self top
]

{ #category : #'*Debugging-Core' }
Context >> storeIntoReceiverVariable: offset [ 
	"Simulate the action of bytecode that stores the top of the stack into an 
	instance variable of my receiver."

	self object: self receiver instVarAt: offset + 1 put: self top
]

{ #category : #'*Debugging-Core' }
Context >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Simulate the action of bytecode that stores the top of the stack at
	 an offset in one of my local variables being used as a remote temp vector."

	(self at: tempVectorIndex + 1) at: remoteTempIndex + 1 put: self top
]

{ #category : #'*Debugging-Core' }
Context >> storeIntoTemporaryVariable: offset [ 
	"Simulate the action of bytecode that stores the top of the stack into one 
	of my temporary variables."

	self at: offset + 1 put: self top
]

{ #category : #'*Debugging-Core' }
Context class >> tallyInstructions: aBlock [
	"This method uses the simulator to count the number of occurrences of
	each of the Smalltalk instructions executed during evaluation of aBlock.
	Results appear in order of the byteCode set."
	| tallies |
	tallies := Bag new.
	thisContext sender
		runSimulated: aBlock
		contextAtEachStep:
			[:current | tallies add: current nextByte].
	^tallies sortedElements

	"Context tallyInstructions: [3.14159 printString]"
]

{ #category : #'*Debugging-Core' }
Context class >> tallyMethods: aBlock [
	"This method uses the simulator to count the number of calls on each method
	invoked in evaluating aBlock. Results are given in order of decreasing counts."
	| prev tallies |
	tallies := Bag new.
	prev := aBlock.
	thisContext sender
		runSimulated: aBlock
		contextAtEachStep:
			[:current |
			current == prev ifFalse: "call or return"
				[prev sender ifNotNil: "call only"
					[tallies add: current printString].
				prev := current]].
	^ tallies sortedCounts

	"Contex tallyMethods: [3.14159 printString]"
]

{ #category : #'*Debugging-Core' }
Context >> tempNamed: aName [
	"Returns the value of the temporaries, aName."

	"Implementation notes: temporary initialization in blocks simply uses pushNil to allocate and initialize each temp.  So if one inspects [|a|a:=2] and sends it self method symbolic you get:

	13 <8F 00 00 05> closureNumCopied: 0 numArgs: 0 bytes 17 to 21
	17 	<73> pushConstant: nil
	18 	<77> pushConstant: 2
	19 	<81 40> storeIntoTemp: 0
	21 	<7D> blockReturn
	22 <7C> returnTop

	And when we check self asContext pc we get 17, which is *before* the nil is pushed. Therefore we should pay attention when querying a temporary if the temporary allocation was executed."

	| index |
	index := self tempNames indexOf: aName.
	^ self namedTempAt: index
]

{ #category : #'*Debugging-Core' }
Context >> tempNamed: aName put: anObject [
	^self namedTempAt: (self tempNames indexOf: aName) put: anObject
]

{ #category : #'*Debugging-Core' }
Context >> tempNames [
	"Answer a SequenceableCollection of the names of the receiver's temporary 
	 variables, which are strings."

	^ self debuggerMap tempNamesForContext: self
]

{ #category : #'*Debugging-Core' }
Context >> temporaryVariableNamed: aName [
	(self hasTemporaryVariableNamed: aName)
		ifFalse: [ ^ nil ].
	^TemporaryVariable name: aName context: self

]

{ #category : #'*Debugging-Core' }
Context >> temporaryVariables [
	^self tempNames collect: [ :name | TemporaryVariable new name: name ]

]

{ #category : #'*Debugging-Core' }
Context >> tempsAndValues [
	"Return a string of the temporary variabls and their current values"
	
	^ String streamContents: [ :aStream |
		self tempNames doWithIndex: [ :title :index |
			 aStream nextPutAll: title; nextPut: $:; space; tab.
			 self print: (self namedTempAt: index) on: aStream.
			 aStream cr ]].
]

{ #category : #'*Debugging-Core' }
Context >> tempsAndValuesLimitedTo: sizeLimit indent: indent [
	"Return a string of the temporary variabls and their current values"

	^ String streamContents: [ :aStream |
		self tempNames doWithIndex: [ :title :index |
			indent timesRepeat: [ aStream tab ].
			aStream nextPutAll: title; nextPut: $:; space; tab.
			aStream nextPutAll: 
				((self namedTempAt: index) printStringLimitedTo: (sizeLimit -3 -title size max: 1)).
			aStream cr ]].
]

{ #category : #'*Debugging-Core' }
Context >> unusedBytecode [
	^ self respondsToUnknownBytecode 
]
