Class {
	#name : #PageRankerItem,
	#superclass : #Object,
	#instVars : [
		'outlinks',
		'previous',
		'current'
	],
	#category : #'PageRank-Core'
}

{ #category : #public }
PageRankerItem >> accumulate: aNumber [
	current := current + aNumber
]

{ #category : #accessing }
PageRankerItem >> current [
	^ current
]

{ #category : #accessing }
PageRankerItem >> current: aNumber [
	current := aNumber
]

{ #category : #accessing }
PageRankerItem >> outlinks [
	^ outlinks
]

{ #category : #accessing }
PageRankerItem >> outlinks: aCollection [
	outlinks := aCollection asArray
]

{ #category : #accessing }
PageRankerItem >> previous [
	^ previous
]

{ #category : #accessing }
PageRankerItem >> previous: aNumber [
	previous := aNumber
]

{ #category : #public }
PageRankerItem >> reset: aNumber [
	previous := current.
	current := aNumber
]
