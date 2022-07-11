extends Node2D

# configurables
export var index = 0
export var texture_index = 0
export var tween_speed = 0.35

onready var sprite = $sprite
onready var move_tween = $move_tween

onready var isMatched = false

# tween position changes
func move(target):
	move_tween.stop_all()
	move_tween.interpolate_property(self, "position", position, target,\
	 tween_speed, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	move_tween.start()
	
# called by the parent grid container to move the node to a
# new postiion on the grid
func set_index(new_index):
	index = new_index
	self.get_parent().move_child(self, index)
	move(Globals.grid.index_positions[index])
	

# Called when the node enters the scene tree for the first time.
func _ready():
	# choose a texture at random and apply to sprite
	randomize()
	texture_index = randi() % 5
	sprite.set_texture(Globals.blocks[texture_index].texture)

