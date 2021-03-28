extends Node2D

var MasterLoudness = 0.5
var MusicLoudness = 0.5
var SoundLoudness = 0.5

signal audio_volume_changed(value)

var cfg

func _ready():
	cfg = ConfigFile.new()
	var err = cfg.load("user://settings.cfg")
	if err == OK:
		set_master_percentage(cfg.get_value("audio", "master", 0.5))
		set_music_percentage(cfg.get_value("audio", "music", 0.5))
		set_sound_percentage(cfg.get_value("audio", "sound", 0.5))
	else:
		# couldn't load settings, use sane defaults
		set_master_percentage(0.5)
		set_music_percentage(0.5)
		set_sound_percentage(0.5)

func set_master_percentage(value):
	MasterLoudness = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(MasterLoudness))
	cfg.set_value("audio", "master", MasterLoudness)
	cfg.save("user://settings.cfg")

func set_music_percentage(value):
	MusicLoudness = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(MusicLoudness))
	cfg.set_value("audio", "music", MusicLoudness)
	cfg.save("user://settings.cfg")

func set_sound_percentage(value):
	SoundLoudness = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"),linear2db(SoundLoudness))
	cfg.set_value("audio", "sound", SoundLoudness)
	cfg.save("user://settings.cfg")
	
func play_piece():
	$PiecePlayer.play()
