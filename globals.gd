extends Node

var grid = {
	'index_positions': {},
	'coords': {}
}

var blocks =  [
	{'name':'red', 'texture': preload("res://sprites/red.png")},
	{'name':'blue', 'texture':preload("res://sprites/blue.png")},
	{'name':'green', 'texture':preload("res://sprites/green.png")},
	{'name':'magenta', 'texture':preload("res://sprites/magenta.png")},
	{'name':'seaweed','texture':preload("res://sprites/seaweed.png")},
]


func dedup_set(array, value):
	if !array.has(value): array.push(value)
