extends Node2D

# configurables
export var index = 0
export var texture_index = 0
export var tween_speed = 0.35

onready var sprite = $sprite
onready var move_tween = $move_tween

onready var isMatched = false
onready var direction_deltas = {
	'right': 1,
	'left': -1,
	'top': 0,
	'bottom': 0
}

var parent
var grid_position = Vector2()


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
	update_grid_position()
	#find_matches()
	
	
# updates the grid x,y position of the tile
func update_grid_position():
	grid_position.x = index % parent.cols
	grid_position.y = floor(index / parent.cols)
	

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


# for each direction progress outward checking for matches
# for every match set isMatched
func find_matches():
	var tiles = parent.get_children()
	var matches = {
		'right': [self],
		'left': [],
		'top': [self],
		'bottom': []
	}
	print()
	print('tile index ', index)
	
	for direction in direction_deltas.keys():
		print('Direction ', direction)
		var delta = direction_deltas[direction]
		var next_index = index + delta
		if !isTileInMatchableLane(next_index, direction): continue
		var tile = tiles[next_index]
		while tile.texture_index == self.texture_index:
			print('matching for: ', next_index)
			tile = tiles[next_index]
			if tile.texture_index != self.texture_index:
				print('Exit')
				break;	
				
			matches[direction].append(tile)
			next_index += delta
			if !isTileInMatchableLane(next_index, direction): break
			
	print()
	var match_list = {
		'horizontal': matches.right + matches.left,
		'vertical': matches.top + matches.bottom
	}
	
	for direction in match_list:
		var matched_tiles = match_list[direction]
		if matched_tiles.size() >= 3:
			for tile in matched_tiles:
				tile.isMatched = true
	
	
# temporary
func dim(): sprite.modulate = Color(1,1,1,0.3)	

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = self.get_parent()
	direction_deltas.top = -parent.cols
	direction_deltas.bottom = parent.cols
	update_grid_position()
	# choose a texture at random and apply to sprite
	randomize()
	texture_index = randi() % 5
	sprite.set_texture(Globals.blocks[texture_index].texture)
	# set grid position for the global
	if !Globals.grid.coords.has(index): 
		Globals.grid.coords[index] = Vector2(index % parent.cols, floor(index / parent.cols))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isMatched: dim()
