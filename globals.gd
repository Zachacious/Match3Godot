extends Node

var grid = {
	'index_positions': {}
}


var blocks =  [
	{'name':'red', 'texture': preload("res://sprites/red.png")},
	{'name':'blue', 'texture':preload("res://sprites/blue.png")},
	{'name':'green', 'texture':preload("res://sprites/green.png")},
	{'name':'magenta', 'texture':preload("res://sprites/magenta.png")},
	{'name':'seaweed','texture':preload("res://sprites/seaweed.png")},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
