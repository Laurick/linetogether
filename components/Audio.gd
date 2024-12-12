extends Node

@onready var audio_sfx_stream_player = $SFXAudioStreamPlayer
@onready var audio_music_stream_player = $MusicAudioStreamPlayer

const dictionary_music = {"Mission":"res://sounds/Mission Plausible.ogg"}
const dictionary_ui = {"click1":"res://sounds/click1.ogg", "switch19":"res://sounds/switch19.ogg"}

var index_bus_master: int;
var index_bus_music: int;
var index_bus_sfx: int; 

func _ready():
	index_bus_master = AudioServer.get_bus_index(&"Master");
	index_bus_music = AudioServer.get_bus_index(&"Music");
	index_bus_sfx = AudioServer.get_bus_index(&"SFX");
	AudioServer.set_bus_volume_db(index_bus_master, linear_to_db(0.5))
	AudioServer.set_bus_volume_db(index_bus_music, linear_to_db(0.5))
	AudioServer.set_bus_volume_db(index_bus_sfx, linear_to_db(0.5))
	
func play_ui_sound(sound_key: String):
	audio_sfx_stream_player.stream = load(dictionary_ui[sound_key])
	audio_sfx_stream_player.pitch_scale = 1
	audio_sfx_stream_player.play(0)
	
func play_ui_sound_random_picth(sound_key: String):
	audio_sfx_stream_player.stream = load(dictionary_ui[sound_key])
	audio_sfx_stream_player.pitch_scale = randf_range(0.97,1.03)
	audio_sfx_stream_player.play(0)


func play_music(music_key: String):
	change_music(music_key)
	audio_music_stream_player.play(0)


func change_music(music_key: String):
	audio_music_stream_player.stream = load(dictionary_music[music_key])


func change_volume_master(new_value):
	if new_value > 1 or new_value < 0:
		printerr("volume cant be >1 or <0")
		return
	AudioServer.set_bus_volume_db(index_bus_master, linear_to_db(new_value))


func change_volume_fsx(new_value):
	if new_value > 1 or new_value < 0:
		printerr("volume cant be >1 or <0")
		return
	AudioServer.set_bus_volume_db(index_bus_sfx, linear_to_db(new_value))


func change_volume_music(new_value):
	if new_value > 1 or new_value < 0:
		printerr("volume cant be >1 or <0")
		return
	_set_audio_volume_music(new_value)


func fade_in_music(time:float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_method(_set_audio_volume_music, 0.0, db_to_linear(AudioServer.get_bus_volume_db(index_bus_music)), time)
	tween.play()


func fade_out_music(time:float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_method(_set_audio_volume_music, db_to_linear(AudioServer.get_bus_volume_db(index_bus_music)), 0.0, time)
	tween.play()


func _set_audio_volume_music(volume:float):
	AudioServer.set_bus_volume_db(index_bus_music, linear_to_db(volume))
