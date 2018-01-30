Class {
	#name : #T2TraitSlotScopeTest,
	#superclass : #T2AbstractTest,
	#category : #'TraitsV2-Tests'
}

{ #category : #tests }
T2TraitSlotScopeTest >> testClassWithTraits [

	| t1 c1 |

	t1 := self newTrait: #T1 with: #() uses: {}.
	c1 := self newClass: #C1 with: #(aSlot) uses: t1.

	self assert: c1 classLayout slotScope parentScope == c1 superclass classLayout slotScope. 
]

{ #category : #tests }
T2TraitSlotScopeTest >> testSubClassAndAddTraitAfter [
	| t1 c1 c2 t2 |

	t1 := self newTrait: #T1 with: #() uses: {}.
	t2 := self newTrait: #T2 with: #() uses: {}.

	c1 := self newClass: #C1 with: #(aSlot) uses: {}.
	c2 := self newClass: #C2 superclass: c1 with: #(otherSlot)  uses: {}.

	self assert: c2 classLayout slotScope parentScope == c2 superclass classLayout slotScope. 
		
	c2 := self newClass: #C1 with: #(aSlot otherSlot) uses: t1.

	self assert: c2 classLayout slotScope parentScope == c2 superclass classLayout slotScope. 
]

{ #category : #tests }
T2TraitSlotScopeTest >> testSubClassWithTraits [

	| t1 c1 c2 t2 |

	t1 := self newTrait: #T1 with: #() uses: {}.
	t2 := self newTrait: #T2 with: #() uses: {}.

	c1 := self newClass: #C1 with: #(aSlot) uses: t1.
	c2 := self newClass: #C2 superclass: c1 with: #(otherSlot)  uses: t2.

	self assert: c2 classLayout slotScope parentScope == c2 superclass classLayout slotScope. 
]

{ #category : #tests }
T2TraitSlotScopeTest >> testSubClassWithTraitsAfterModification [

	| t1 c1 c2 t2 |

	t1 := self newTrait: #T1 with: #() uses: {}.
	t2 := self newTrait: #T2 with: #() uses: {}.

	c1 := self newClass: #C1 with: #(aSlot) uses: t1.
	c2 := self newClass: #C2 superclass: c1 with: #(otherSlot)  uses: t2.

	self assert: c2 classLayout slotScope parentScope == c2 superclass classLayout slotScope.

	c2 := self newClass: #C2 superclass: c1 with: #(otherSlot another)  uses: t2.


]

{ #category : #tests }
T2TraitSlotScopeTest >> testSubClassWithTraitsAfterModificationOfParent [

	| t1 c1 c2 t2 |

	t1 := self newTrait: #T1 with: #() uses: {}.
	t2 := self newTrait: #T2 with: #() uses: {}.

	c1 := self newClass: #C1 with: #(aSlot) uses: t1.
	c2 := self newClass: #C2 superclass: c1 with: #(otherSlot)  uses: t2.

	c2 := self newClass: #C1 with: #(aSlot otherSlot) uses: t2.

	self assert: c2 classLayout slotScope parentScope == c2 superclass classLayout slotScope. 
]
