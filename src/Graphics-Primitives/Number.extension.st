Extension { #name : #Number }

{ #category : #'*Graphics-Primitives' }
Number >> @ y [ 
	"Primitive. Answer a Point whose x value is the receiver and whose y 
	value is the argument. Optional. No Lookup. See Object documentation 
	whatIsAPrimitive."

	<primitive: 18>
	^Point x: self y: y
]

{ #category : #'*Graphics-Primitives' }
Number >> asMargin [
	^ Margin fromNumber: self.
]
