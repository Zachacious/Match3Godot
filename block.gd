extends Node2D

export var index = 0
export var texture_index = 0
export var tween_speed = 0.35
export var points_value = 100

onready var sprite = $sprite
onready var move_tween = $move_tween
onready var destroy_animation = $destroy/AnimationPlayer
onready var destroy_sprite = $destroy
onready var destroy_sound = $destroy/destroy_sound
onready var swap_sound = $sprite/swap_sound

onready var isMatched = false
onready var direction_deltas = {
	'right': 1,
	'left': -1,
	'top': 0,
	'bottom': 0
}

var parent

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
	move(Globals.grid.index_positions[index])
	
# part of find_matches
# determine if a tile index is within the bounds of the grid
func isTileInMatchableLane(tile_index, direction):
	if tile_index < 0 or tile_index > parent.total_tiles-1: 
		return false
	var tile_coords = Globals.grid.coords[tile_index]
	var cur_coords = Globals.grid.coords[index]
	if (direction == 'right' or direction == 'left') and tile_coords.y != cur_coords.y: 
		return false
	if (direction == 'top' or direction == 'bottom') and tile_coords.x != cur_coords.x: 
		return false

	return true

# For each direction, progress outward checking for matches.
# For every match, set isMatched true
# returns true if at least one match of 3 is made
# called by the parent grid when this tile is moved
func find_matches():
	var matches_were_made = false
	var tiles = parent.grid_tiles
	# store matches for each direction
	var matches = {
		'right': [self],
		'left': [],
		'top': [self],
		'bottom': []
	}
	
	# iterate each direction
	for direction in direction_deltas.keys():
		var delta = direction_deltas[direction]
		# move the index from this tile in the selected direction
		var next_index = index + delta
		# if the next tile is out of bounds - move to next direction
		if !isTileInMatchableLane(next_index, direction): continue
		var tile = tiles[next_index]
		if tile == null: continue
		# as long as the next tile in the current direction is a match
		# and is in-bounds continue iterating and setting matches
		while tile.texture_index == self.texture_index:
			tile = tiles[next_index]
			if tile == null: break
			if tile.texture_index != self.texture_index: break
			matches[direction].append(tile)
			next_index += delta
			if !isTileInMatchableLane(next_index, direction): break
			
	# need to comine direction so we can match
	# for col/row
	var match_list = {
		'horizontal': matches.right + matches.left,
		'vertical': matches.top + matches.bottom
	}
	
	# check horizontal and vertical matches
	# if it has 3 or more set isMatched on each
	for direction in match_list:
		var matched_tiles = match_list[direction]
		if matched_tiles.size() >= 3:
			matches_were_made = true
			for tile in matched_tiles:
				tile.isMatched = true
				
	return matches_were_made

func destroy():
	sprite.modulate = Color(1,1,1,0)
	destroy_sprite.modulate = Color(1,1,1,1)
	destroy_animation.play("destroy")	
	destroy_sound.play()

# regenerate texture
func regen_texture():
	# choose a texture at random and apply to sprite
	randomize()
	texture_index = randi() % 5
	sprite.set_texture(Globals.blocks[texture_index].texture)

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = self.get_parent()
	direction_deltas.top = -parent.cols
	direction_deltas.bottom = parent.cols
	regen_texture()
	destroy_sprite.modulate = Color(1,1,1,0)
	
	# set grid position for the global
	# lookup table
	if !Globals.grid.coords.has(index): 
		Globals.grid.coords[index] = Vector2(index % parent.cols, floor(index / parent.cols))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#if ready_for_deletion: queue_free() # delete this from the tree
	if isMatched: destroy()
