Class {
	#name : 'SistaMethodZone',
	#superclass : 'CogMethodZone',
	#instVars : [
		'allocationThreshold',
		'thresholdRatio'
	],
	#category : 'VMMaker-JIT',
	#package : 'VMMaker',
	#tag : 'JIT'
}

{ #category : 'translation' }
SistaMethodZone class >> declareCVarsIn: aCCodeGenerator [
	aCCodeGenerator
		declareVar: 'allocationThreshold' type: #usqInt;
		var: 'thresholdRatio' declareC: (BytesPerWord = 8 ifTrue: ['double thresholdRatio = 0.5'] ifFalse: ['float thresholdRatio = 0.5f'])
]

{ #category : 'allocating' }
SistaMethodZone >> allocationLimit [
	<inline: true>
	^super allocationLimit min: allocationThreshold
]

{ #category : 'initialization' }
SistaMethodZone >> computeAllocationThreshold [
	<inline: true>
	allocationThreshold := ((limitAddress - baseAddress * thresholdRatio) asUnsignedInteger + (self zoneAlignment - 1) truncateTo: self zoneAlignment) + baseAddress
]

{ #category : 'allocating' }
SistaMethodZone >> effectiveLimit [
	<inline: true>
	^super effectiveLimit min: allocationThreshold
]

{ #category : 'accessing' }
SistaMethodZone >> getCogCodeZoneThreshold [
	<api>
	<returnTypeC: #double>
	^thresholdRatio
]

{ #category : 'initialization' }
SistaMethodZone >> initialize [
	super initialize.
	thresholdRatio := 0.5
]

{ #category : 'initialization' }
SistaMethodZone >> manageFrom: theStartAddress to: theLimitAddress [
	super manageFrom: theStartAddress to: theLimitAddress.
	self computeAllocationThreshold
]

{ #category : 'accessing' }
SistaMethodZone >> setCogCodeZoneThreshold: ratio [
	<api>
	<var: #ratio type: #double>
	(ratio >= 0.1 and: [ratio <= 1.0]) ifFalse:
		[^PrimErrBadArgument].
	thresholdRatio := ratio.
	self computeAllocationThreshold.
	^0
]
