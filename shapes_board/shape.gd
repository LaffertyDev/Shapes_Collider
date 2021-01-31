extends Node2D

export(int) var Board_X = 0
export(int) var Board_Y = 0

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
