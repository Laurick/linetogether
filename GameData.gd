extends Node

# config_data
var master_volume
var music_volume
var sfx_volume
var lang
var show_connections


# player_data
var level_index:int = 0
var unlocked_level_index:int = 0


# game_data
var max_riddles


func _ready() -> void:
	load_config()
	TranslationServer.set_locale(GameData.lang)

func load_config():
	var dict:ConfigFile = FileUtils.new().read_config()
	master_volume = dict.get_value("config","master_volume", 0.5)
	music_volume = dict.get_value("config", "music_volume", 0.5)
	sfx_volume = dict.get_value("config", "sfx_volume", 0.5)
	lang = dict.get_value("config", "lang", OS.get_locale())
	show_connections = dict.get_value("config", "show_connections", false)


func save_config():
	var config:Dictionary = {}
	config["master_volume"] = master_volume
	config["music_volume"] = music_volume
	config["sfx_volume"] = sfx_volume
	config["lang"] = lang
	config["show_connections"] = show_connections
	FileUtils.new().save_config(config)


func get_player_data() -> Dictionary:
	return {"unlocked_level_index":unlocked_level_index}


func from_player_data_dict(data:Dictionary):
	unlocked_level_index = data.get("unlocked_level_index", 1)
