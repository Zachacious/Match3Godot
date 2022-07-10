extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Input handler, listen for ESC to exit app
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() 
#	if(event.is_pressed()):
#		if(event.scancode == KEY_ESCAPE):
#			get_tree().quit() 
