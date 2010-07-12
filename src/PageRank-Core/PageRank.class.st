Class {
	#name : #PageRank,
	#superclass : #Object,
	#instVars : [
		'damping',
		'iterations',
		'stepBlock',
		'referencedBlock'
	],
	#category : #'PageRank-Core'
}

{ #category : #'instance creation' }
PageRank class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
PageRank >> damping: aNumber [
	"The damping factor represents the probability the flow will continue at any step. The default value is 0.85."

	damping := aNumber asFloat
]

{ #category : #initialization }
PageRank >> initialize [
	self iterations: 100; damping: 0.85.
	self referenced: [ :node | #() ].
	self step: [ :iteration | ]
]

{ #category : #accessing }
PageRank >> iterations: anInteger [
	"The number of iterations defines how many times the calculation is repeated, more iterations give more accurate results. The default value is 100."
	
	iterations := anInteger asInteger
]

{ #category : #private }
PageRank >> mappingFor: aCollection [
	| sentinel nodes |
	sentinel := Object new.
	nodes := IdentityDictionary new: aCollection size.
	aCollection 
		do: [ :node | nodes at: node put: PageRankNode new ].
	nodes keysAndValuesDo: [ :node :item |
		item 
			nodes: (((referencedBlock value: node)
				collect: [ :each | nodes at: each ifAbsent: [ sentinel ] ])
				reject: [ :each | each == sentinel or: [ each == node ] ]);
			previous: 1.0 / aCollection size;
			current: 1.0 - damping ].
	^ nodes
]

{ #category : #accessing }
PageRank >> referenced: aOneArgumentBlock [
	"Defines how the referenced nodes of a given element are retrieved."

	referencedBlock := aOneArgumentBlock
]

{ #category : #public }
PageRank >> runOn: aCollection [
	| nodes items inverse |
	nodes := self mappingFor: aCollection.
	items := nodes values asArray.
	inverse :=  1.0 - damping.
	1 to: iterations do: [ :counter |
		items do: [ :node |
			node nodes
				do: [ :child | child accumulate: (damping * node previous / node nodes size) ] ].
		items do: [ :item | item reset: inverse ].
		stepBlock value: counter ].
	nodes associationsDo: [ :assoc | assoc value: assoc value previous ].
	^ nodes
]

{ #category : #accessing }
PageRank >> step: aOneArgumentBlock [
	"The block evaluated with each iteration step."
	
	stepBlock := aOneArgumentBlock
]
