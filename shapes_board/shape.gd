extends Node2D

export(int) var Board_X = 0
export(int) var Board_Y = 0

func set_position_to_grid():
	set_position(Vector2(Board_X * 30, Board_Y * 30))
