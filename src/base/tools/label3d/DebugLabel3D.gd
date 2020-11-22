tool
extends Spatial

export var text: String setget set_text


func set_text(new_text):
	$Viewport/Label.text = new_text
