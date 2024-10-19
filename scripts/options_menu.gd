extends Control


func _on_exit_options_button_pressed() -> void:
	print("Exit Options Button Pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
