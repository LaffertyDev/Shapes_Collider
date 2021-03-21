extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Main_Menu_pressed():
	var err = get_tree().change_scene("res://main_menu/main_menu.tscn")
	if err != OK:
		print("There was a failure changing the scene")

func _on_Reset_pressed():
	var err = get_tree().change_scene("res://shapes_board/shapes_board.tscn")
	if err != OK:
		print("There was a failure changing the scene")
	pass