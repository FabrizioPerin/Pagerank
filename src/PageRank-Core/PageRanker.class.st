Class {
	#name : #PageRanker,
	#superclass : #Object,
	#instVars : [
		'damping',
		'iterations',
		'outlinks'
	],
	#category : #'PageRank-Core'
}

{ #category : #accessing }
PageRanker >> damping: aNumber [
	"The damping factor represents the probability the flow will continue at any step. The deafult value is 0.85."

	damping := aNumber asFloat
]

{ #category : #initialization }
PageRanker >> initialize [
	self iterations: 100; damping: 0.85.
	self outlinks: [ :node | #() ]
]

{ #category : #accessing }
PageRanker >> iterations: anInteger [
	"The number of iterations defines how many times the calculation is repeated, more iterations give more accurate results. The default value is 100."
	
	iterations := anInteger
]

{ #category : #private }
PageRanker >> mappingFor: aCollection [
	| zork nodes |
	zork := Object new.
	nodes := IdentityDictionary new: aCollection size.
	aCollection 
		do: [ :node | nodes at: node put: PageRankerItem new ].
	nodes keysAndValuesDo: [ :node :item |
		item 
			outlinks: (((outlinks value: node)
				collect: [ :each | nodes at: each ifAbsent: [ zork ] ])
				reject: [ :each | each == zork or: [ each == node ] ]);
			previous: 1.0 / aCollection size;
			current: 1.0 - damping ].
	^ nodes
]

{ #category : #accessing }
PageRanker >> outlinks: aBlock [
	"Defines how the children of a given element are retrieved."

	outlinks := aBlock
]

{ #category : #public }
PageRanker >> runOn: aCollection [
	| nodes items inverse |
	nodes := self mappingFor: aCollection.
	items := nodes values asArray.
	inverse :=  1.0 - damping.
	iterations timesRepeat: [
		items do: [ :item |
			item outlinks
				do: [ :child | child accumulate: (damping * item previous / item outlinks size) ] ].
		items do: [ :item | item reset: inverse ] ].
	nodes associationsDo: [ :assoc | assoc value: assoc value previous ].
	^ nodes
]
