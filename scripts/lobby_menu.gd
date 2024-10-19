extends Control

@export var ip_line_edit: LineEdit
@export var status_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_button_pressed() -> void:
	Lobby.create_game()


func _on_join_button_pressed() -> void:
	status_label.text = "Connection Status: Connecting..."
	if ip_line_edit:
		Lobby.join_game(ip_line_edit.text)


func _on_start_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_lobby_button_pressed() -> void:
	print("Exit Lobby Menu Button Pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
