extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Score_Update(new_score):
	var format_str = "%05d";
	$Score.text = format_str % new_score
