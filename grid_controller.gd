extends Node2D

export var cols = 7
export var rows = 10
export var tile_size = 64
export var padding = 4

onready var pad_factor = padding * 2
onready var full_tile_size = tile_size + pad_factor
onready var width = full_tile_size * (cols-1)
onready var height = full_tile_size * (rows-1)
onready var total_tiles = cols * rows
onready var tile_coord_offset = Vector2(full_tile_size,full_tile_size)/2

var first_touch = Vector2(0,0)
var final_touch = Vector2(0,0)

var tiles = []

func create_tiles():
	for i in range(0, total_tiles):
		var tile = preload("res://block.tscn").instance()
		
		tile.index = i
		var tile_pos = Vector2((i % cols) * full_tile_size, (i / cols) * full_tile_size)
		tile.position = tile_pos
		Globals.grid.index_positions[i] = tile_pos

		self.add_child(tile)
		tiles.append(tile)
		
func swap_tiles(tile_a, tile_b):
	var index_a = tile_a.index
	var index_b = tile_b.index
	tile_a.set_index(index_b);
	tile_b.set_index(index_a);
	
func view_coords_to_grid_coords(coords):
	return coords + tile_coord_offset
	
func grid_xy_to_index(coords):
	return ((coords.y - 1)*cols) + coords.x
	
func coords_to_tile_index(coords):
	var grid_space_coords = view_coords_to_grid_coords(coords)
	var x = floor(grid_space_coords.x / full_tile_size)+1
	var y = floor(grid_space_coords.y / full_tile_size)+1
	return grid_xy_to_index(Vector2(x,y))
	
func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		first_touch = self.get_local_mouse_position()
		print('click start ',coords_to_tile_index(first_touch))
	if Input.is_action_just_released("ui_touch"):
		final_touch = self.get_local_mouse_position()
		print('dropped ',coords_to_tile_index(final_touch))
		

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x -= width/2
	self.position.y -= height/2
	create_tiles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	touch_input()
