Class {
	#name : #PageRankerTest,
	#superclass : #TestCase,
	#instVars : [
		'graph',
		'ranks',
		'ranker'
	],
	#category : #'PageRank-Core'
}

{ #category : #'as yet unclassified' }
PageRankerTest >> setUp [
	super setUp.
	graph := Dictionary new.
	graph at: #a put: #(c).
	graph at: #b put: #(a).
	graph at: #c put: #(a).
	graph at: #d put: #(c b).
	ranker := PageRanker new.
	ranker outlinks: [ :node | graph at: node ]
]

{ #category : #'as yet unclassified' }
PageRankerTest >> testFirstStep [
	ranker iterations: 1; damping: 1.
	ranks := ranker runOn: graph keys.
	self assert: (ranks at: #a) = 0.5.
	self assert: (ranks at: #b) = 0.125.
	self assert: (ranks at: #c) = 0.375.
	self assert: (ranks at: #d) = 0.0.
]

{ #category : #'as yet unclassified' }
PageRankerTest >> testInitialStep [
	ranker iterations: 0; damping: 1.
	ranks := ranker runOn: graph keys.
	self assert: (ranks at: #a) = 0.25.
	self assert: (ranks at: #b) = 0.25.
	self assert: (ranks at: #c) = 0.25.
	self assert: (ranks at: #d) = 0.25.
]

{ #category : #'as yet unclassified' }
PageRankerTest >> testSecondStep [
	ranker iterations: 2; damping: 1.
	ranks := ranker runOn: graph keys.
	self assert: (ranks at: #a) = 0.5.
	self assert: (ranks at: #b) = 0.0.
	self assert: (ranks at: #c) = 0.5.
	self assert: (ranks at: #d) = 0.0.
]
