Class {
	#name : #TaClassCompositionElement,
	#superclass : #TaCompositionElement,
	#category : #'TraitsV2-Compositions'
}

{ #category : #accessing }
TaClassCompositionElement >> slots [
	^ (innerClass slots
		reject: [ :e | TraitedClassTrait slots anySatisfy: [ :x | x name = e name ] ])
		collect: [ :e | self copySlot: e ]
]

{ #category : #printing }
TaClassCompositionElement >> traitCompositionExpression [
	
	^ innerClass baseClass name , ' classTrait'
]
