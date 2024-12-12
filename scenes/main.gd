extends Control

@onready var continue_button: Button = $VBoxContainer/ContinueButton


func _ready() -> void:
	continue_button.disabled = !FileUtils.new().filegame_exists()
	Audio.play_music("Mission")


func _on_exit_button_pressed() -> void:
	get_tree().quit(0)


func _on_play_button_pressed() -> void:
	GameData.from_player_data_dict({})
	get_tree().change_scene_to_file("res://scenes/level_selector.tscn")


func _on_continue_button_pressed() -> void:
	var player_data = FileUtils.new().get_filegame_data()
	GameData.from_player_data_dict(player_data)
	get_tree().change_scene_to_file("res://scenes/level_selector.tscn")
