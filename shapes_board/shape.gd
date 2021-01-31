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
	match ShapeOption:
		Enums.ShapeOptions.I:
			shape_local_grid = shape_i.duplicate(true)
		Enums.ShapeOptions.J:
			shape_local_grid = shape_j.duplicate(true)
		Enums.ShapeOptions.L:
			shape_local_grid = shape_l.duplicate(true)
		Enums.ShapeOptions.O:
			shape_local_grid = shape_o.duplicate(true)
		Enums.ShapeOptions.S:
			shape_local_grid = shape_s.duplicate(true)
		Enums.ShapeOptions.T:
			shape_local_grid = shape_t.duplicate(true)
		Enums.ShapeOptions.Z:
			shape_local_grid = shape_z.duplicate(true)

	update_position()

func rotate_clockwise():
	var size = shape_local_grid.size()
	var layers = size / 2
	for layer in range(0, layers):
		var first = layer
		var last = size - first - 1
		for element in range(first, last):
			var offset = element - first
			var top = shape_local_grid[first][element]
			var right = shape_local_grid[element][last]
			var bottom = shape_local_grid[last][last - offset]
			var left = shape_local_grid[last - offset][first]
			
			shape_local_grid[first][element] = left
			shape_local_grid[element][last] = top
			shape_local_grid[last][last - offset] = right
			shape_local_grid[last - offset][first] = bottom
	update_position()


func update_position():
	var block_indices = []
	block_indices.resize(4)
	var block_index = 0
	for x in range(0, shape_local_grid.size()):
		for y in range(0, shape_local_grid.size()):
			if shape_local_grid[x][y]:
				block_indices[block_index] = Vector2(y, x)
				block_index += 1
	
	$Sprite1.set_position(block_indices[0] * 30)
	$Sprite2.set_position(block_indices[1] * 30)
	$Sprite3.set_position(block_indices[2] * 30)
	$Sprite4.set_position(block_indices[3] * 30)

func set_position_to_grid():
	set_position(Vector2(Board_X * 30, Board_Y * 30))

func deactivate():
	var res = load("res://shapes_board/Shape_Block.tscn")
	for n in range(0, 4):
		var block = res.instance()
		block.Board_X = self.Board_X
		block.Board_Y = self.Board_Y + n
		block.texture.region = $Sprite.texture.region
		get_parent().add_child(block)
		block.set_position_to_grid()
	hide()
	queue_free()
