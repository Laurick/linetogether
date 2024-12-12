extends Control

signal show_connections_changes(new_value)

const LANG = {"es":"Español", "en":"English"}

@export var can_erase_progress:bool = false

@onready var erase_progress_button: Button = $GridContainer/EraseProgressButton
@onready var lang_option_button: OptionButton = $GridContainer/LangOptionButton
@onready var music_value: Label = $GridContainer/MusicValue
@onready var sound_value: Label = $GridContainer/SoundValue
@onready var master_value: Label = $GridContainer/MasterValue

func _ready() -> void:
	erase_progress_button.disabled = !can_erase_progress
	for l in LANG.values():
		lang_option_button.add_item(l)
	$GridContainer/MasterHSlider.value = GameData.master_volume*100
	master_value.text = str(GameData.master_volume*100)
	$GridContainer/MusicHSlider.value = GameData.music_volume*100
	music_value.text = str(GameData.music_volume*100)
	$GridContainer/SoundHSlider.value = GameData.sfx_volume*100
	sound_value.text = str(GameData.sfx_volume*100)
	$GridContainer/ShowConnectionsCheckBox.button_pressed = GameData.show_connections
	if !LANG.has(GameData.lang):
		GameData.lang = "en"
		GameData.save_config()
	lang_option_button.select(LANG.keys().find(GameData.lang))
		
	
func _on_erase_progress_button_pressed() -> void:
	var confirmation_dialog:ConfirmationDialog = ConfirmationDialog.new()
	confirmation_dialog.title = "CONFIRMATION_ERASE_PROGRESS_DIALOG_TITLE"
	confirmation_dialog.get_label().text = "CONFIRMATION_ERASE_PROGRESS_DIALOG_MESSAGE"
	confirmation_dialog.ok_button_text = "CONFIRMATION_ERASE_PROGRESS_OK_BUTTON"
	confirmation_dialog.cancel_button_text = "CONFIRMATION_ERASE_PROGRESS_NO_BUTTON"
	confirmation_dialog.confirmed.connect(erase_progrees)
	add_child(confirmation_dialog)


func erase_progrees():
	var fu:FileUtils = FileUtils.new()
	fu.erase_save_data()


func _on_show_connections_check_box_toggled(toggled_on: bool) -> void:
	GameData.show_connections = toggled_on
	show_connections_changes.emit(toggled_on)
	GameData.save_config()


func _on_lang_option_button_item_selected(index: int) -> void:
	match(index):
		0:
			GameData.lang = "es"
			TranslationServer.set_locale("es")
		1:
			GameData.lang = "en"
			TranslationServer.set_locale("en")
		_:
			GameData.lang = "en"
			TranslationServer.set_locale("en")
	GameData.save_config()

func _on_music_h_slider_value_changed(value: float) -> void:
	var value_precentile = value/100
	music_value.text = str(value)
	Audio.change_volume_music(value_precentile)
	GameData.music_volume = value_precentile


func _on_master_h_slider_value_changed(value: float) -> void:
	var value_precentile = value/100
	master_value.text = str(value)
	Audio.change_volume_master(value_precentile)
	GameData.master_volume = value_precentile


func _on_sound_h_slider_value_changed(value: float) -> void:
	sound_value.text = str(value)


func _on_master_h_slider_drag_ended(_value_changed: bool) -> void:
	GameData.save_config()


func _on_music_h_slider_drag_ended(_value_changed: bool) -> void:
	GameData.save_config()


func _on_sound_h_slider_drag_ended(_value_changed: bool) -> void:
	var new_value = $GridContainer/SoundHSlider.value/100
	Audio.change_volume_fsx(new_value)
	GameData.sfx_volume = new_value
	Audio.play_ui_sound_random_picth("switch19")
	GameData.save_config()
