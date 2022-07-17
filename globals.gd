extends Node

signal score_set

var grid = {
	'index_positions': {},
	'coords': {}
}

var score = 0

#var blocks =  [
#	{'name':'red', 'texture': preload("res://sprites/red.png")},
#	{'name':'blue', 'texture':preload("res://sprites/blue.png")},
#	{'name':'green', 'texture':preload("res://sprites/green.png")},
#	{'name':'magenta', 'texture':preload("res://sprites/magenta.png")},
#	{'name':'seaweed','texture':preload("res://sprites/seaweed.png")},
#]

var blocks =  [
	{'name':'cat', 'texture': preload("res://sprites/monsters/cat.png")},
	{'name':'lizard', 'texture':preload("res://sprites/monsters/lizard.png")},
	{'name':'owl', 'texture':preload("res://sprites/monsters/owl.png")},
	{'name':'pig', 'texture':preload("res://sprites/monsters/pig.png")},
	{'name':'rabbit','texture':preload("res://sprites/monsters/rabbit.png")},
]

var tile_tween = null


func set_score(value):
	print('SET_SCORE ', value)
	score = value
	emit_signal('score_set')
