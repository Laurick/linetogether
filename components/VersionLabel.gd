class_name VersionLabel
extends Label

func _ready():
	var version:String = ProjectSettings.get_setting("application/config/version")
	text = version
