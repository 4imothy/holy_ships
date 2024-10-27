extends Control

var beeper = null

func _on_exit_options_button_pressed() -> void:
	queue_free()

func _on_texture_rect_mouse_entered() -> void:
	beeper.play()
