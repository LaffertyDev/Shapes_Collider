extends Node2D

# tetris generally has a 10x22 grid size
export(int) var GridWidth = 10 # X
export(int) var GridDepth = 22 # Y, bottom right = (9, 21)
var rng
var current_shape;

var shapes_grid;

var score = 0

signal score_points(score)

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize() # seed rng with system time
	spawn_shape(get_random_shape_option())
	shapes_grid = []
	shapes_grid.resize(GridWidth)
	for x in GridWidth:
		shapes_grid[x] = []
		shapes_grid[x].resize(GridDepth)
	var globals = get_node("/root/Globals")
	globals.connect("difficulty_changed", self, "_on_Difficulty_Change")
	_on_Difficulty_Change(globals.CurrentDifficulty)
	$ShapeTimer.start()

func _unhandled_input(event):
	if !is_paused():
		if event.is_action_pressed("ui_left"):
			attempt_move_left(current_shape)
		
		if event.is_action_pressed("ui_right"):
			attempt_move_right(current_shape)
			
		if event.is_action_pressed("ui_down"):
			attempt_move_down(current_shape)

		if event.is_action_pressed("ui_rotate"):
			if current_shape.can_rotate_clockwise(shapes_grid):
				current_shape.rotate_clockwise()

	if event.is_action_pressed("ui_toggle_menu"):
		if !is_paused():
			print('group does not exist yet')
			var options_res = load("res://options_menu/options_menu.tscn")
			var options_menu = options_res.instance()
			options_menu.connect("menu_open", self, "_handle_menu_open")
			options_menu.connect("menu_closed", self, "_handle_menu_closed")
			get_parent().add_child(options_menu);
			options_menu.mark_menu_as_game()
		else:
			get_tree().call_group("menu", "close", false) # tell menu to close without going to main menu

func _handle_menu_open():
	$ShapeTimer.stop()

func _handle_menu_closed():
	$ShapeTimer.start()

func _difficulty_To_Timer(difficulty):
	match difficulty:
		1:
			return 1.0
		2:
			return 0.6
		3:
			return 0.4
		4:
			return 0.15
		5:
			return 0.05
		_:
			print("Invalid Difficulty Option")
			return 0.001

func _on_Difficulty_Change(difficulty):
	$ShapeTimer.wait_time = _difficulty_To_Timer(difficulty)

func _on_ShapeTimer_timeout():
	if !can_move_down(current_shape):
		current_shape.deactivate()
		attempt_clear_rows()
		var potential_shape = get_random_shape_option()
		if can_spawn_shape(potential_shape):
			spawn_shape(get_random_shape_option())
		else:
			var err = get_tree().change_scene("res://game_over/game_over.tscn")
			if err != OK:
				print("There was a failure changing the scene")

	else:
		attempt_move_down(current_shape)

func is_paused():
	return get_tree().has_group("menu")

func get_random_shape_option():
	return rng.randi_range(0, Enums.ShapeOptions.size() - 1)

func attempt_clear_rows():
	var rows_cleared = 0
	for y in range(GridDepth):
		var row_needs_cleared = true
		for x in range(GridWidth):
			row_needs_cleared = row_needs_cleared && (shapes_grid[x][y] != null)

		if row_needs_cleared:
			rows_cleared += 1
			for x in range(0, GridWidth):
				# clear the row that needs cleared, deleting sprites
				shapes_grid[x][y].hide()
				shapes_grid[x][y].queue_free()
			for y_clear in range(y, 0, -1):
				for x in range(0, GridWidth):
					# move all lines down by one that are above this row
					shapes_grid[x][y_clear] = shapes_grid[x][y_clear - 1] 
					shapes_grid[x][y_clear - 1] = null 
					if (shapes_grid[x][y_clear] != null):
						shapes_grid[x][y_clear].set_position(Vector2((x * 31) + 15, (y_clear * 31) + 15))

	register_score(rows_cleared)

func register_score(rows_cleared):
	if (rows_cleared == 0):
		return
	
	# https://tetris.wiki/Scoring
	match rows_cleared:
		1:
			score += 40
		2:
			score += 100
		3:
			score += 300
		4:
			score += 1200

	emit_signal('score_points', score)

func can_spawn_shape(option):
	var shape = load("res://shapes_board/Shape.tscn").instance()
	shape.Board_X = (GridWidth / 2)
	shape.Board_Y = 0
	var potential_shape_local_grid = shape.get_matrix_from_shape(option)
	var potential_shape_grid = shape._get_global_grid_positions(potential_shape_local_grid)
	var can_spawn = true
	for potential_block in potential_shape_grid:
		if (shapes_grid[potential_block.x][potential_block.y] != null):
			can_spawn = false
			break

	shape.free()
	return can_spawn

func spawn_shape(option):
	var shape = load("res://shapes_board/Shape.tscn").instance()
	shape.ShapeOption = option
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
		$ShapeTimer.start() # reset timer
	else:
		print("At bottom")

func can_move_left(shape):
	var current_grid = shape.get_global_grid_positions()
	for block in current_grid:
		if !(block.x > 0):
			return false
		
		if (shapes_grid[block.x - 1][block.y] != null):
			return false

	return true

func can_move_right(shape):
	var current_grid = shape.get_global_grid_positions()
	for block in current_grid:
		if !(block.x < GridWidth - 1):
			return false
		
		if (shapes_grid[block.x + 1][block.y] != null):
			return false

	return true

func can_move_down(shape):
	var current_grid = shape.get_global_grid_positions()
	for block in current_grid:
		if !(block.y < GridDepth - 1):
			return false
		
		if (shapes_grid[block.x][block.y + 1] != null):
			return false

	return true
