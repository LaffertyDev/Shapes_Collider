extends Node2D

# tetris generally has a 10x22 grid size
export(int) var GridWidth = 10 # X
export(int) var GridDepth = 22 # Y, bottom right = (9, 21)

var current_shape;

var shapes_grid;

func _ready():
	spawn_shape()
	shapes_grid = []
	shapes_grid.resize(GridWidth)
	for x in GridWidth:
		shapes_grid[x] = []
		shapes_grid[x].resize(GridDepth)

func _input(event):
	if event.is_action_pressed("ui_left"):
		attempt_move_left(current_shape)
	
	if event.is_action_pressed("ui_right"):
		attempt_move_right(current_shape)
		
	if event.is_action_pressed("ui_down"):
		attempt_move_down(current_shape)
		
	if event.is_action_pressed("ui_rotate"):
		if current_shape.can_rotate_clockwise(shapes_grid):
			current_shape.rotate_clockwise()

func _on_ShapeTimer_timeout():
	if !can_move_down(current_shape):
		current_shape.deactivate()
		spawn_shape()
	else:
		attempt_move_down(current_shape)
	
func spawn_shape():
	var shape = load("res://shapes_board/Shape.tscn").instance()
	shape.ShapeOption = Enums.ShapeOptions.L
	shape.Board_X = (GridWidth / 2)
	shape.Board_Y = 0
	shape.set_position_to_grid()
	$Grid.add_child(shape)
	current_shape = shape

func attempt_move_left(shape):
	if can_move_left(shape):
		shape.Board_X -= 1
		shape.set_position_to_grid()
	else:
		print("Cannot go left")

func attempt_move_right(shape):
	if can_move_right(shape):
		shape.Board_X += 1
		shape.set_position_to_grid()
	else:
		print("Cannot go right")

func attempt_move_down(shape):
	if can_move_down(shape):
		shape.Board_Y += 1
		shape.set_position_to_grid()
	else:
		print("At bottom")

func can_move_left(shape):
	var current_grid = shape.get_global_grid_positions()
	for block in current_grid:
		if !(block.x > 0):
			return false
		
		if (shapes_grid[block.x - 1][block.y] == true):
			return false

	return true
	
func can_move_right(shape):
	var current_grid = shape.get_global_grid_positions()
	for block in current_grid:
		if !(block.x < GridWidth - 1):
			return false
		
		if (shapes_grid[block.x + 1][block.y] == true):
			return false

	return true

func can_move_down(shape):
	var current_grid = shape.get_global_grid_positions()
	for block in current_grid:
		if !(block.y < GridDepth - 1):
			return false
		
		if (shapes_grid[block.x][block.y + 1] == true):
			return false

	return true
