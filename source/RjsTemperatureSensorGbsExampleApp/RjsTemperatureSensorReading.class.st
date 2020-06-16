"
Examples:

	(self newTemperature: 20 asOf: (DateTime now addSeconds: -86401)) recordSample.
	(self currentTemperature: 42) recordSample.
	(self newTemperature: 70 asOf: (DateTime now addSeconds: 86401)) recordSample.
	self sampleReport inspect.
	self clearReadings.

GemStone Set Up:
	1) Execute ""RjsTemperatureSensorReading clearReadings."" in VA Smalltalk to initialize the class variable.
	2) Use GBS to push the class to the server.
	3) Execute ""RjsTemperatureSensorReading clearReadings."" in GemStone to initialize the class variable.
	4) Commit.
	5) Evaluate the following in VA Smalltalk (client Execute):
		| session connector |
		session := GBSM currentSession.
		connector := GbsClassVarConnector
				stName: #RjsTemperatureSensorReading
				gsName: #RjsTemperatureSensorReading
				cvarName: #Readings.
		connector updateSTOnConnect.
		connector connectInSession: session.
		
		
		((session evaluate: '
			RjsTemperatureSensorReading clearReadings. ""start clean; not something you would normally do.""
			(RjsTemperatureSensorReading newTemperature: 20 asOf: (DateTime now addSeconds: -86401)) recordSample.
			(RjsTemperatureSensorReading currentTemperature: 42) recordSample.
			(RjsTemperatureSensorReading newTemperature: 70 asOf: (DateTime now addSeconds: 86401)) recordSample.
			RjsTemperatureSensorReading sampleReport')
				copyReplacing: Character cr withObject: Character lf)
					inspect.
		session commitTransaction.
		
		RjsTemperatureSensorReading sampleReport inspect.
	6) There will be two inspectors. The first showing the server's report, with CRs replaced by LFs.
	   And the second showing that the readings have been replicated back to the client. Note the date format differences.
	7) New client readings will be propagated to the server when you do a ""session commitTransaction"".
		(RjsTemperatureSensorReading currentTemperature: 35) recordSample.
		GBSM commitTransaction.
		((GBSM evaluate: 'RjsTemperatureSensorReading sampleReport')
				copyReplacing: Character cr withObject: Character lf)
					inspect.

"
Class {
	#name : 'RjsTemperatureSensorReading',
	#superclass : 'Object',
	#instVars : [
		'whenTaken',
		'temperature'
	],
	#classVars : [
		'Readings'
	],
	#category : 'RjsTemperatureSensorGbsExampleApp'
}

{ #category : 'recording' }
RjsTemperatureSensorReading class >> clearReadings [

	Readings := OrderedCollection new.
]

{ #category : 'instance creation' }
RjsTemperatureSensorReading class >> newTemperature: anInteger asOf: aTimestamp [

	^self new
		initializeWithTemperature: anInteger andTimestamp: aTimestamp;
		yourself.
]

{ #category : 'accessing' }
RjsTemperatureSensorReading class >> readings [

	Readings isNil ifTrue: [self clearReadings].
	^Readings
]

{ #category : 'recording' }
RjsTemperatureSensorReading class >> recordSample: aTemperatureSensorReading [

	self readings add: aTemperatureSensorReading.
]

{ #category : 'accessing' }
RjsTemperatureSensorReading class >> sampleReport [

	| stream |
	stream := WriteStream on: String new.
	stream nextPutAll: '#	Temperature	When Taken'.

	self readings doWithIndex: [:eachReading :index |
		stream cr;
			print: index; tab;
			print: eachReading temperature; tab;
			print: eachReading whenTaken].
	
	^stream contents
			
]

{ #category : 'initializing - private' }
RjsTemperatureSensorReading >> initializeWithTemperature: anInteger andTimestamp: aTimestamp [

	self
		temperature: anInteger;
		whenTaken: aTimestamp.
]

{ #category : 'printing' }
RjsTemperatureSensorReading >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		print: self temperature;
		nextPutAll: ' @ ';
		print: self whenTaken;
		nextPutAll: ')'
]

{ #category : 'recording' }
RjsTemperatureSensorReading >> recordSample [

	self class recordSample: self.
]

{ #category : 'accessing' }
RjsTemperatureSensorReading >> temperature [

	^temperature

]

{ #category : 'updating - private' }
RjsTemperatureSensorReading >> temperature: anInteger [

	temperature := anInteger

]

{ #category : 'accessing' }
RjsTemperatureSensorReading >> whenTaken [

	^whenTaken

]

{ #category : 'updating - private' }
RjsTemperatureSensorReading >> whenTaken: aTimestamp [

	whenTaken := aTimestamp

]
