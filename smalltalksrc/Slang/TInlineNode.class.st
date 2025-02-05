Class {
	#name : 'TInlineNode',
	#superclass : 'TParseNode',
	#instVars : [
		'method'
	],
	#category : 'Slang-AST',
	#package : 'Slang',
	#tag : 'AST'
}

{ #category : 'visiting' }
TInlineNode >> accept: aVisitor [
	
	^ aVisitor visitInlineNode: self
]

{ #category : 'tranforming' }
TInlineNode >> asCASTIn: aBuilder [

	^ method asCASTInlinedIn: aBuilder
]

{ #category : 'transformations' }
TInlineNode >> bindVariableUsesIn: aDictionary [
	method := method bindVariableUsesIn: aDictionary.

]

{ #category : 'transformations' }
TInlineNode >> bindVariableUsesIn: aDictionary andConstantFoldIf: constantFold in: codeGen [
	"Answer either the receiver, if it contains no references to the given variables, or a new node with the given variables rebound."
	| newMethod |
	newMethod := method bindVariableUsesIn: aDictionary andConstantFoldIf: constantFold in: codeGen.
	^newMethod = method
		ifTrue: [self]
		ifFalse: [self shallowCopy
					method: newMethod;
					yourself]
]

{ #category : 'transformations' }
TInlineNode >> bindVariablesIn: aDictionary [

	method := method bindVariablesIn: aDictionary.

]

{ #category : 'transformations' }
TInlineNode >> bindVariablesIn: aDictionary unless: cautionaryBlock [

	(cautionaryBlock value: self) ifTrue: [^self].
	method := method bindVariablesIn: aDictionary unless: cautionaryBlock.

]

{ #category : 'accessing' }
TInlineNode >> children [

	^ { method }
]

{ #category : 'testing' }
TInlineNode >> isInline [
	^true
]

{ #category : 'comparing' }
TInlineNode >> isSameAs: anotherNode [
	
	^ anotherNode isInline
		and: [ method selector = anotherNode method selector
			and: [ method parseTree isSameAs: anotherNode method parseTree ] ]
]

{ #category : 'accessing' }
TInlineNode >> method [
	^method
]

{ #category : 'accessing' }
TInlineNode >> method: aTMethod [
	method := aTMethod
]

{ #category : 'enumerating' }
TInlineNode >> nodesDo: aBlock [
	"Apply aBlock to all nodes in the receiver.
	 N.B. This is assumed to be bottom-up, leaves first."
	method parseTree nodesDo: aBlock.
	aBlock value: self
]

{ #category : 'enumerating' }
TInlineNode >> nodesDo: aBlock parent: parent [
	"Apply aBlock to all nodes in the receiver with each node's parent.
	 N.B. This is assumed to be bottom-up, leaves first."
	method parseTree nodesDo: aBlock parent: self.
	aBlock value: self value: parent
]

{ #category : 'enumerating' }
TInlineNode >> nodesDo: aBlock parent: parent unless: cautionaryBlock [

	(cautionaryBlock value: self value: parent) ifTrue: [^self].
	method parseTree nodesDo: aBlock parent: self unless: cautionaryBlock.
	aBlock value: self value: parent
]

{ #category : 'enumerating' }
TInlineNode >> nodesDo: aBlock unless: cautionaryBlock [

	(cautionaryBlock value: self) ifTrue: [^self].
	method parseTree nodesDo: aBlock unless: cautionaryBlock.
	aBlock value: self.
]

{ #category : 'copying' }
TInlineNode >> postCopy [

	method := method copy
]

{ #category : 'printing' }
TInlineNode >> printOn: aStream level: anInteger [
	method parseTree printOn: aStream level: anInteger
]

{ #category : 'transformations' }
TInlineNode >> replaceNodesIn: map [
	^map at: self ifAbsent: [
		method replaceNodesIn: map.
		self]
]

{ #category : 'inlining' }
TInlineNode >> shouldExpand [
	^method extractExpandCaseDirective
]

{ #category : 'type inference' }
TInlineNode >> typeOrNilFrom: aCodeGenerator in: aTMethod [
	^method returnType
]
