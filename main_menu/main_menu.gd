extends Control

func _ready():
	pass # Replace with function body.


func _on_New_Game_pressed():
	var err = get_tree().change_scene("res://shapes_board/shapes_board.tscn")
	if err != OK:
		print("There was a failure changing the scene")

func _on_Exit_pressed():
	get_tree().quit()
