Class {
	#name : #PageRankNode,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'previous',
		'current'
	],
	#category : #'PageRank-Core'
}

{ #category : #public }
PageRankNode >> accumulate: aNumber [
	current := current + aNumber
]

{ #category : #accessing }
PageRankNode >> current [
	^ current
]

{ #category : #accessing }
PageRankNode >> current: aNumber [
	current := aNumber
]

{ #category : #accessing }
PageRankNode >> nodes [
	^ nodes
]

{ #category : #accessing }
PageRankNode >> nodes: aCollection [
	nodes := aCollection asArray
]

{ #category : #accessing }
PageRankNode >> previous [
	^ previous
]

{ #category : #accessing }
PageRankNode >> previous: aNumber [
	previous := aNumber
]

{ #category : #public }
PageRankNode >> reset: aNumber [
	previous := current.
	current := aNumber
]
