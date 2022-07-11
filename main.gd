extends Node2D

#Input handler, listen for ESC to exit app
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() 
