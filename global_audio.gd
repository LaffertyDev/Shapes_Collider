extends Node2D

var MasterLoudness = 0.5
var MusicLoudness = 0.5
var SoundLoudness = 0.5

signal audio_volume_changed(value)

func _ready():
	set_master_percentage(0.5)
	set_music_percentage(0.5)
	set_sound_percentage(0.5)

func set_master_percentage(value):
	MasterLoudness = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(MasterLoudness))

func set_music_percentage(value):
	MusicLoudness = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(MusicLoudness))

func set_sound_percentage(value):
	SoundLoudness = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"),linear2db(SoundLoudness))
