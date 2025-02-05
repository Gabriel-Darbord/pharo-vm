Class {
	#name : 'ComposedMetadataStruct',
	#superclass : 'VMStructType',
	#instVars : [
		'startAddress',
		'dataSize'
	],
	#category : 'VMMaker-ImageFormat',
	#package : 'VMMaker',
	#tag : 'ImageFormat'
}

{ #category : 'simulation only' }
ComposedMetadataStruct class >> byteSizeForSimulator: aCogit [

	"Answer an approximation of the byte size of an AbstractInstruction struct.
	 This is for estimating the alloca in allocateOpcodes:bytecodes:ifFail:"
	^self instSize * (aCogit sizeof: #'void *'). 
]

{ #category : 'translation' }
ComposedMetadataStruct class >> instVarNamesAndTypesForTranslationDo: aBinaryBlock [
	"enumerate aBinaryBlock with the names and C type strings for the inst vars to include in a struct of this type."

	<var: #dataSize type: #size_t>
	<var: #startAddress type: #squeakFileOffsetType>

	aBinaryBlock
		value: 'dataSize' value:'size_t';
		value: 'startAddress' value:'squeakFileOffsetType'.
	

]

{ #category : 'accessing' }
ComposedMetadataStruct >> dataSize [

	^ dataSize
]

{ #category : 'accessing' }
ComposedMetadataStruct >> dataSize: anObject [

	dataSize := anObject
]

{ #category : 'initialization' }
ComposedMetadataStruct >> initialize [

	startAddress := 0.
	dataSize := 0
]

{ #category : 'accessing' }
ComposedMetadataStruct >> startAddress [

	^ startAddress
]

{ #category : 'accessing' }
ComposedMetadataStruct >> startAddress: anObject [

	startAddress := anObject
]
