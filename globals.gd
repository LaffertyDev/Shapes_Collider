extends Node

var CurrentDifficulty

signal difficulty_changed(value)

var cfg

func _ready():
	cfg = ConfigFile.new()
	var err = cfg.load("user://settings.cfg")
	if err == OK:
		set_difficulty(cfg.get_value("game", "difficulty", 1))
	else:
		set_difficulty(1)

func set_difficulty(value):
	CurrentDifficulty = value
	emit_signal("difficulty_changed", value)
	cfg.set_value("game", "difficulty", CurrentDifficulty)
	cfg.save("user://settings.cfg")
