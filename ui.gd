extends Node2D

export var width = 600
export var height = 1024

onready var score_label = $score_panel/Label


func size_and_position():
	var screen_w = get_viewport().size.x
	var screen_h = get_viewport().size.y
	var scale_factor = 1
	
	if screen_w < 600:
		scale_factor = screen_w / 600
		scale = Vector2(scale_factor, scale_factor)
		
	position.x = screen_w/2 - (width*scale_factor)/2
	position.y = screen_h/2 - (height*scale_factor)/2
	
	
	
func _update_score():
	score_label.text = str(Globals.score)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "size_and_position")
	position.x -= width/2
	position.y -= height/2
	size_and_position()
	_update_score()
	Globals.connect("score_set", self, "_update_score")

