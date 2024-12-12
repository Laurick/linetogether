class_name LineButton extends TextureButton

const SEGMENTS_META_KET = "segments"

signal line_selected(segments)

@onready var label: Label = $Label


func _ready() -> void:
	pressed.connect(on_button_pressed)
	var text:String = str(get_meta(SEGMENTS_META_KET, 0))
	label.text = text


func on_button_pressed() -> void:
	line_selected.emit(get_meta(SEGMENTS_META_KET, 0))


func update_number_of_lines_by(amount:int):
	var new_amount = get_meta(SEGMENTS_META_KET, 0)+amount
	var text:String = str(new_amount)
	label.text = text
	set_meta(SEGMENTS_META_KET, new_amount)
