"
A SistaCogMethod is a CogMethod with a pointer to memory holding the Sista performance counters decremented in conditional branches.

Instance Variables
	counters:		<pointer>

counters
	- counters points to the first field of either a pinned object on the Spur heap or malloced memory.

"
Class {
	#name : 'SistaCogMethod',
	#superclass : 'CogMethod',
	#instVars : [
		'counters'
	],
	#category : 'VMMaker-JIT',
	#package : 'VMMaker',
	#tag : 'JIT'
}

{ #category : 'class initialization' }
SistaCogMethod class >> initialize [
	"self initialize"
	(Smalltalk classNamed: #CogSistaMethodSurrogate32) ifNotNil:
		[:cms32|
		self checkGenerateSurrogate: cms32 bytesPerWord: 4].
	(Smalltalk classNamed: #CogSistaMethodSurrogate64) ifNotNil:
		[:cms64|
		self checkGenerateSurrogate: cms64 bytesPerWord: 8]
]

{ #category : 'translation' }
SistaCogMethod class >> structTypeName [
	"Provide the typedef name."
	^superclass structTypeName
]

{ #category : 'accessing' }
SistaCogMethod >> counters [
	"Answer the value of counters"

	^ counters
]

{ #category : 'accessing' }
SistaCogMethod >> counters: anObject [
	"Set the value of counters"

	^counters := anObject
]
