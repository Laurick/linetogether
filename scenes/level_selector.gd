extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var number_of_riddles: int = 0
	var riddle_directory: DirAccess = DirAccess.open("res://riddles/")
	var riddles: PackedStringArray  = riddle_directory.get_files()
	for riddle_index in riddles.size():
		var b:Button = Button.new()
		var index: int = riddle_index+1
		b.text = tr("LEVEL_FORMAT_NAME_SELECTOR") % index
		b.set_meta("level",index)
		b.pressed.connect(on_level_pressed.bind(index))
		b.disabled = index > GameData.unlocked_level_index
		grid_container.add_child(b)
		number_of_riddles += 1
	GameData.max_riddles = number_of_riddles


func on_level_pressed(index) -> void:
	GameData.level_index = index
	var path: String = "res://scenes/line_seeker.tscn"
	get_tree().change_scene_to_file(path)
