# For simplicity and effecientcy, I'm using a 1d 'flat' array for the grid
# the x,y positions of where each tile should be displayed are stored in a dictionary for
# fast lookups when moving tiles around

extends Node2D

# configurables
export var cols = 7
export var rows = 10
export var tile_size = 64
export var padding = 4

# constants
var pad_factor = padding * 2 # the total amount of width or height that will be added
var full_tile_size = tile_size + pad_factor # size of tile + padding
var width = full_tile_size * (cols-1) # full pixel width of grid
var height = full_tile_size * (rows-1) # full pixel height of grid
var total_tiles = cols * rows # total num of tiles on the grid
# offset needed to convert mouse coords to grid space
var tile_coord_offset = Vector2(full_tile_size,full_tile_size)/2 

# for detecting the first and final tiles to swap
var first_tile = -1
var first_coords = Vector2()
var final_tile = -1

var grid_tiles = []

func create_tile(tile_index, subplant = false):
	var tile = preload("res://block.tscn").instance()
	tile.index = tile_index
	# calc pixel position
	var tile_pos = Vector2((tile_index % cols) * full_tile_size, (tile_index / cols) * full_tile_size)
	tile.position = tile_pos
	# store the position for this index in the global hash map for fast lookups
	Globals.grid.index_positions[tile_index] = tile_pos
	self.add_child(tile) # actually add to the render tree
	if !subplant: grid_tiles.append(tile)
	else: grid_tiles[tile_index] = tile


# creates all the tiles needed to fill the grid
func create_tiles():
	for i in range(0, total_tiles):
		create_tile(i)


# swaps 2 tiles in the render tree	
func swap_tiles(tile_a, tile_b):
	if tile_a == null or tile_b == null: return
	# cache current indicies
	var index_a = tile_a.index
	var index_b = tile_b.index

	grid_tiles[index_a] = tile_b
	grid_tiles[index_b] = tile_a
	# allow each tile to move themselves
	tile_a.set_index(index_b)
	tile_b.set_index(index_a)
	yield(get_tree().create_timer(.2), "timeout")
	var a_has_matches = tile_a.find_matches()
	var b_has_matches = tile_b.find_matches()
	# wait for the movement tweens to finish
	#yield(get_tree().create_timer(.2), "timeout")
	
	# if no matches were made - move them back
	if !a_has_matches and !b_has_matches:
		# Move them back
		grid_tiles[index_a] = tile_a
		grid_tiles[index_b] = tile_b
		tile_a.set_index(index_a)
		tile_b.set_index(index_b)
	else:
		yield(get_tree().create_timer(.3), "timeout")
		remove_matches()
		yield(get_tree().create_timer(.2), "timeout")
		collapse_columns()
	
	
# converts coords from full viewport space into grid space
# - simply adds a small offset needed to get it right
# - the coords passed should be local(relative) mouse coords
func view_coords_to_grid_coords(coords):
	return coords + tile_coord_offset 


# converts tile x,y position into the corresponding index
# (because we're using a flat array)
func grid_xy_to_index(coords):
	return ((coords.y - 1)*cols) + coords.x


# returns the tile index on the grid under the coords passed in
func coords_to_tile_index(coords):
	var grid_space_coords = view_coords_to_grid_coords(coords)
	# reject anything outside the bounds of the grid
	# the y axis will take care of itself by checking the index
	if grid_space_coords.x > width + full_tile_size or grid_space_coords.x < 0:
		return -1
		
	# get the grid x,y position from the adjusted mouse coords
	var x = floor(grid_space_coords.x / full_tile_size)+1
	var y = floor(grid_space_coords.y / full_tile_size)+1
	
	# get the index
	var index = grid_xy_to_index(Vector2(x,y))-1
	
	# checks if the y-axis is in line by checking the index
	return index if index > -1 and index <= total_tiles - 1 else -1
	
	
# handle input for mouse/touch	
func touch_input():
	# on initial touch
	if Input.is_action_just_pressed("ui_touch"):
		# local coords are relative to the grid
		first_coords = self.get_local_mouse_position()
		# cache the tile the mouse is over
		first_tile = coords_to_tile_index(first_coords)

	# on release
	if Input.is_action_just_released("ui_touch"):
		var coords = self.get_local_mouse_position()
		# get the relative direction of the mouse
		# create an offset that moves the initial touch
		# position over one tile in the direction of the mouse
		# movement - use those coordinates to get the tile
		# that we need to swap with
		var delta = (coords - first_coords).normalized().snapped(Vector2(1,1)) # right = 1,0
		# need to block diagonal movement - if neither delta value is 0 - bail
		if delta.x != 0 and delta.y !=0: return
		var final_offset = Vector2(full_tile_size, full_tile_size) * delta
		coords = first_coords + final_offset

		
		# get the tile that the touch was released on
		final_tile = coords_to_tile_index(coords)
		# make sure we're dealing with tiles that are
		# within the bounds of the grid
		if first_tile > -1 and final_tile > -1:
			# get the update list of tiles
			var tiles = grid_tiles
			# perform the swap on those tiles
			swap_tiles(tiles[first_tile], tiles[final_tile])

func remove_matches():
	for tile_index in range(0, grid_tiles.size()):
		var tile = grid_tiles[tile_index]
		if tile != null && tile.isMatched:
			grid_tiles[tile_index] = null
			remove_child(tile)
			tile.queue_free()
			
			
func collapse_columns():
	for col in cols:
		var start_index = col
		var cur_index = col
		var distance = cols # move the index this much to reach next row 
		# we need to store each tile as we go down
		var unmatched_tiles = []
		var matched_tiles = []
		for cell in rows+1:
			var tile = 0 if cur_index >= total_tiles else grid_tiles[cur_index]
			if tile != null:
				if matched_tiles.size() == 0: unmatched_tiles.append(tile)
				else: 
					for unmatched_tile in unmatched_tiles:
						var move_offset = distance * matched_tiles.size()
						var old_index = unmatched_tile.index
						var new_index = unmatched_tile.index + move_offset
						grid_tiles[new_index] = unmatched_tile
						unmatched_tile.set_index(new_index)
						#grid_tiles[old_index] = null

					for matched_iter in range(0, matched_tiles.size()):
						var index = start_index + (matched_iter * distance)
						create_tile(index, true)

					break;
						
			else:
				matched_tiles.append(tile)
				
			cur_index += distance
			print(get_children().size())
			
	
func refill_columns():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	# The grid is already center positioned on the screen
	# we need to offset it with the size of the created grid
	self.position.x -= width/2
	self.position.y -= height/2
	create_tiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	touch_input()
