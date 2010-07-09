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

{ #category : #accessing }
PageRanker >> outlinks: aBlock [
	"Defines how the children of a given element are retrieved."

	outlinks := aBlock
]

{ #category : #actions }
PageRanker >> runOn: aNodeCollection [
	| previous |
	previous := IdentityDictionary new: aNodeCollection size.
	aNodeCollection
		do: [ :each | previous at: each put: 1.0 / aNodeCollection size ].
	iterations timesRepeat: [
		| current |
		current := IdentityDictionary new: aNodeCollection size.
		previous keysAndValuesDo: [ :node :rank |
			| children |
			current
				at: node
				ifAbsentPut: [ 1.0 - damping ].
			(children := (outlinks value: node) reject: [ :each | each == node ]) do: [ :child |
				current
					at: child
					put: (current
						at: child
						ifAbsent: [ 1.0 - damping ]) + (damping * rank / children size) ] ].
		previous := current ].
	^ previous
]
