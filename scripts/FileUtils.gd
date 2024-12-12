class_name FileUtils

const SAVE_GAME_DIR = "user://"
const SAVE_GAME_FILE = "save.json"
const CONFIG_FILE = "user://settings.cfg"

func filegame_exists() -> bool:
	var dir_acc = DirAccess.get_files_at(SAVE_GAME_DIR)
	return dir_acc.find("save.json") > -1


func get_filegame_data() -> Dictionary:
	var full_path =  SAVE_GAME_DIR+"/"+SAVE_GAME_FILE
	var file_acc = FileAccess.open(full_path, FileAccess.READ)
	var content = file_acc.get_as_text()
	return JSON.parse_string(content)


func save_data_into_filegame(data:Dictionary):
	var full_path =  SAVE_GAME_DIR+"/"+SAVE_GAME_FILE
	var file_acc = FileAccess.open(full_path, FileAccess.WRITE)
	file_acc.store_string(JSON.stringify(data))

func erase_save_data():
	var full_path =  SAVE_GAME_DIR+"/"+SAVE_GAME_FILE
	DirAccess.remove_absolute(full_path)

func read_config():
	var config = ConfigFile.new()

	var err = config.load(CONFIG_FILE)

	if err != OK:
		return {}

	return config

func save_config(data:Dictionary):
	var config = ConfigFile.new()

	for key in data:
		config.set_value("config", key, data[key])

	config.save(CONFIG_FILE)
