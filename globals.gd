extends Node

signal score_set
signal moves_set

var grid = {
	'index_positions': {},
	'coords': {}
}

var score = 0
var moves = 20

var blocks =  [
	{'name':'cat', 'texture': preload("res://sprites/monsters/cat.png")},
	{'name':'lizard', 'texture':preload("res://sprites/monsters/lizard.png")},
	{'name':'owl', 'texture':preload("res://sprites/monsters/owl.png")},
	{'name':'pig', 'texture':preload("res://sprites/monsters/pig.png")},
	{'name':'rabbit','texture':preload("res://sprites/monsters/rabbit.png")},
]

func set_score(value):
	print('SET_SCORE ', value)
	score = value
	emit_signal('score_set')
	
func dec_moves():
	moves -= 1
	emit_signal('moves_set')
