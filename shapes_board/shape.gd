extends Node2D

export(int) var Board_X = 0
export(int) var Board_Y = 0

export(Enums.ShapeOptions) var ShapeOption

# Shape Static Definitions
const shape_i = [[false, true, false, false], [false, true, false, false], [false, true, false, false], [false, true, false, false]]
const shape_j = [[false, true, false], [false, true, false], [true, true, false]]
const shape_l = [[false, true, false], [false, true, false], [false, true, true]]
const shape_o = [[false, false, false, false], [false, true, true, false], [false, true, true, false], [false, false, false, false]]
const shape_s = [[false, true, true], [true, true, false], [false, false, false]]
const shape_t = [[true, true, false], [false, true, true], [false, false, false]]
const shape_z = [[false, true, false], [true, true, true], [false, false, false]]

var shape_local_grid

func _ready():
	shape_local_grid = get_matrix_from_shape(ShapeOption);
	$Sprite1.texture.region = Rect2(ShapeOption * 30, 0, 30, 30)
	$Sprite2.texture.region = Rect2(ShapeOption * 30, 0, 30, 30)
	$Sprite3.texture.region = Rect2(ShapeOption * 30, 0, 30, 30)
	$Sprite4.texture.region = Rect2(ShapeOption * 30, 0, 30, 30)
	update_position()

func get_matrix_from_shape(shape_option):
	match shape_option:
		Enums.ShapeOptions.I:
			return shape_i.duplicate(true)
		Enums.ShapeOptions.J:
			return shape_j.duplicate(true)
		Enums.ShapeOptions.L:
			return shape_l.duplicate(true)
		Enums.ShapeOptions.O:
			return shape_o.duplicate(true)
		Enums.ShapeOptions.S:
			return shape_s.duplicate(true)
		Enums.ShapeOptions.T:
			return shape_t.duplicate(true)
		Enums.ShapeOptions.Z:
			return shape_z.duplicate(true)

func can_rotate_clockwise(global_grid):
	var rotated_local_grid = get_rotate_clockwise()
	var rotated_global_coords = _get_global_grid_positions(rotated_local_grid)
	for rotated_block in rotated_global_coords:
		if rotated_block.x < 0 || rotated_block.x >= global_grid.size():
			return false
		
		if rotated_block.y < 0 || rotated_block.y >= global_grid[0].size():
			return false
	
		if (global_grid[rotated_block.x][rotated_block.y] != null):
			return false
	
	return true

func get_rotate_clockwise():
	var grid_to_rotate = shape_local_grid.duplicate(true)
	var size = grid_to_rotate.size()
	var layers = size / 2
	for layer in range(0, layers):
		var first = layer
		var last = size - first - 1
		for element in range(first, last):
			var offset = element - first
			var top = grid_to_rotate[first][element]
			var right = grid_to_rotate[element][last]
			var bottom = grid_to_rotate[last][last - offset]
			var left = grid_to_rotate[last - offset][first]
			
			grid_to_rotate[first][element] = left
			grid_to_rotate[element][last] = top
			grid_to_rotate[last][last - offset] = right
			grid_to_rotate[last - offset][first] = bottom
	return grid_to_rotate
	
func rotate_clockwise():
	shape_local_grid = get_rotate_clockwise()
	update_position()

# update the blocks (after a rotation) so they are in the right places visually
func update_position():
	var block_indices = get_local_grid_positions(shape_local_grid)

	# this doesn't need to be offset because its local to this parent
	$Sprite1.set_position(Vector2(block_indices[0].x * 31, block_indices[0].y * 31))
	$Sprite2.set_position(Vector2(block_indices[1].x * 31, block_indices[1].y * 31))
	$Sprite3.set_position(Vector2(block_indices[2].x * 31, block_indices[2].y * 31))
	$Sprite4.set_position(Vector2(block_indices[3].x * 31, block_indices[3].y * 31))
	
func get_global_grid_positions():
	return _get_global_grid_positions(shape_local_grid)

func _get_global_grid_positions(local_grid_matrix):
	var global_indices = []
	var local_indices = get_local_grid_positions(local_grid_matrix)
	for block in local_indices:
		global_indices.append(Vector2(block.x + self.Board_X, block.y + self.Board_Y))
	return global_indices

func get_local_grid_positions(local_grid_matrix):
	var block_indices = []
	block_indices.resize(4)
	var block_index = 0
	for y in range(0, local_grid_matrix.size()): # how arrays work, first size is the Y
		for x in range(0, local_grid_matrix.size()):
			if local_grid_matrix[y][x]:
				block_indices[block_index] = Vector2(x, y)
				block_index += 1
	return block_indices

# Update the entire tetrimino's position relative to the parent
func set_position_to_grid():
	# offset relative to grid (so left-most pixel is touching the grid)
	set_position(Vector2((Board_X * 31) + 15, (Board_Y * 31) + 15))

func deactivate():
	var blocks_global = _get_global_grid_positions(shape_local_grid)
	for block in blocks_global:
		var child = get_children()[0]
		remove_child(child)
		get_parent().add_child(child)
		get_node("../..").shapes_grid[block.x][block.y] = child
		child.set_position(Vector2((block.x * 31) + 15, (block.y * 31) + 15)) # offset because now there is no local offsetting
	
	queue_free()
	hide()
