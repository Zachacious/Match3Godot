extends Node2D

# export var pos = Vector2(0,0)
export var isMatched = false
export var index = 0
export var texture_index = 0

onready var sprite = self.get_node("sprite")

func set_index(new_index):
	index = new_index
	self.position = Globals.grid.index_positions[index]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	texture_index = randi() % 5
	sprite.set_texture(Globals.blocks[texture_index].texture)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
