class_name ChangeVisibilityComponent extends Node

var target

func _ready() -> void:
	target = get_parent()
	

func change_visibility(visibility:bool):
	target.visible = visibility
