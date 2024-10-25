extends Control

@onready var beeper = $AudioStreamPlayer2D

func _on_exit_options_button_pressed() -> void:
	print("Exit Options Button Pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_texture_rect_mouse_entered() -> void:
	beeper.play()
