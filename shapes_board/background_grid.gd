extends Node2D

export (int) var line_rows = 22
export (int) var line_columns = 10
export (int) var block_width = 30

func _draw():
	var background_color = Color(0.2, 0.2, 0.2)
	for row in range(0, line_rows + 1):
		# draw horizontal lines
		# Y-axis is drawn below the horizon... so it is off by one?
		draw_line(Vector2(0, row * (block_width + 1)), Vector2((block_width + 1) * line_columns, (row * (block_width + 1)) - 1), background_color, -1.0, false)
	for col in range(0, line_columns + 1):
		# draw vertical lines
		draw_line(Vector2(col * (block_width + 1), 0), Vector2(col * (block_width + 1), line_rows * (block_width + 1)), background_color, 1.0, false)

