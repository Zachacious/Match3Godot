extends Node2D

export var width = 600
export var height = 1024
export var tween_speed = .35

onready var score_label = $score_panel/Label
onready var animation_player = score_label.get_node("player")
onready var moves_label = $Control/Moves/label_node/Label
onready var moves_node = $Control/Moves/label_node
onready var tween = $Control/tween


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
	animation_player.play("score_jump")
	
func _update_moves():
	moves_label.text = str(Globals.moves)
	moves_node.scale = Vector2(2,2)
	tween.stop_all()
	tween.interpolate_property(moves_node, "scale", moves_node.scale, Vector2(1,1),\
	 tween_speed, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "size_and_position")
	position.x -= width/2
	position.y -= height/2
	size_and_position()
	_update_score()
	_update_moves()
	Globals.connect("score_set", self, "_update_score")
	Globals.connect("moves_set", self, "_update_moves")

