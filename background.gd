extends Control

onready var bk = $sprite

func size_and_position():
	var screen_w = get_viewport().size.x
	var screen_h = get_viewport().size.y
	var dir = 'horizontal' if screen_w > screen_h else 'vertical'
	if dir == 'horizontal':
		var scale_factor =  (screen_h / bk.get_rect().size.y)
		rect_scale = Vector2(scale_factor, scale_factor)
	elif dir == 'vertical':
		var scale_factor = (screen_h / bk.get_rect().size.y)
		rect_scale = Vector2(scale_factor, scale_factor)
	
	set_position(Vector2(screen_w/2, screen_h/2))

# Called when the node enters the scene tree for the first time.
func _ready():
	size_and_position()
	get_tree().get_root().connect("size_changed", self, "size_and_position")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
