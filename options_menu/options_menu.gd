extends Control

var isInGame = false

signal difficulty_changed(difficulty)
signal menu_open()
signal menu_closed()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("menu")
	$HBoxContainer/VBoxContainer/return_to_main_menu.hide()
	emit_signal("menu_open")

#menu exit
#go back to main menu only if we are not in a game
func _on_exit_button_pressed():
	close(!isInGame)

func set_ui_difficulty(difficulty):
	$HBoxContainer/VBoxContainer/difficulty_slider.value = difficulty

func mark_menu_as_game():
	isInGame = true
	$HBoxContainer/VBoxContainer/return_to_main_menu.show()

func close(goToMainMenu):
	emit_signal("menu_closed")
	self.hide()
	self.queue_free()

	if goToMainMenu:
		# state should go back to main menu
		_go_to_main_menu()

# go back to main menu
# should only fire if we are in the game
func _on_return_to_main_menu_pressed():
	close(true)

func _go_to_main_menu():
	var err = get_tree().change_scene("res://main_menu/main_menu.tscn")
	if err != OK:
		print("There was a failure changing the scene")

func _on_difficulty_slider_value_changed(value):
	emit_signal("difficulty_changed", int(value))
