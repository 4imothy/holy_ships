extends Control

const BBCode_FILE_PATH = "res://static/credits.txt"

@export var text_box: RichTextLabel
var beeper = null

func _ready():
	var file = FileAccess.open(BBCode_FILE_PATH, FileAccess.READ)
	var bbcode_text = file.get_as_text()
	file.close()
	text_box.bbcode_text = bbcode_text
	
func _on_rich_text_label_meta_clicked(value: Variant) -> void:
	OS.shell_open(value)


func _on_exit_pressed() -> void:
	beeper.play()
	queue_free()
