extends Control

@onready var grid_container: GridContainer = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var riddle_directory = DirAccess.open("res://riddles/")
	var riddles = riddle_directory.get_files()
	print(riddles)
	for riddle_index in riddles.size():
		var b:Button = Button.new()
		var index = riddle_index+1
		b.text = "Level %d" % index
		b.set_meta("level",index)
		b.pressed.connect(on_level_pressed.bind(index))
		grid_container.add_child(b)


func on_level_pressed(index) -> void:
	GameData.level_index = index
	var path = "res://line_seeker/line_seeker.tscn"
	get_tree().change_scene_to_file(path)
