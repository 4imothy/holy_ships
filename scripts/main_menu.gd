extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainMenuMusic.play_main_menu_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	print("Start Button Pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/lobby_menu.tscn")


func _on_options_button_pressed() -> void:
	print("Options Button Pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/options_menu.tscn")


func _on_exit_button_pressed() -> void:
	print("Exit Button Pressed")
	get_tree().quit()
