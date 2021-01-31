extends Node2D

# tetris generally has a 10x22 grid size
export(int) var GridWidth = 10 # X
export(int) var GridDepth = 22 # Y, bottom right = (9, 21)

var current_shape;

func _ready():
	spawn_shape()

func _input(event):
	if event.is_action_pressed("ui_left"):
		attempt_move_left(current_shape)
	
	if event.is_action_pressed("ui_right"):
		attempt_move_right(current_shape)
		
	if event.is_action_pressed("ui_down"):
		attempt_move_down(current_shape)
		
	if event.is_action_pressed("ui_rotate"):
		current_shape.rotate_clockwise()

func _on_ShapeTimer_timeout():
	if current_shape.Board_Y == GridDepth - 1:
		current_shape.deactivate()
		spawn_shape()
	else:
		attempt_move_down(current_shape)
	
func spawn_shape():
	var shape = load("res://shapes_board/Shape.tscn").instance()
	shape.ShapeOption = Enums.ShapeOptions.T
	shape.Board_X = (GridWidth / 2)
	shape.Board_Y = 0
	shape.set_position_to_grid()
	$Grid.add_child(shape)
	current_shape = shape
		
func attempt_move_left(shape):
	if shape.Board_X > 0:
		shape.Board_X -= 1
		shape.set_position_to_grid()
	else:
		print("Cannot go left")

func attempt_move_right(shape):
	if shape.Board_X < GridWidth - 1:
		shape.Board_X += 1
		shape.set_position_to_grid()
	else:
		print("Cannot go right")

func attempt_move_down(shape):
	if shape.Board_Y < GridDepth - 1:
		shape.Board_Y += 1
		shape.set_position_to_grid()
	else:
		print("At bottom")
