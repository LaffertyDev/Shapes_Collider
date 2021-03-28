extends Node

var CurrentDifficulty = 1

signal difficulty_changed(value)

func set_difficulty(value):
	CurrentDifficulty = value
	emit_signal("difficulty_changed", value)