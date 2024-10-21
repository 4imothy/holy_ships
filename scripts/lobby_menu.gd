extends Node

@export var ui: Control
@export var level_container: Node
@export var level_scene: PackedScene
@export var ip_line_edit: LineEdit
@export var status_label: Label
@export var not_connected_hbox: HBoxContainer
@export var host_hbox: HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)

### Button Presses ###
func _on_host_button_pressed() -> void:
	not_connected_hbox.hide()
	status_label.text = "Connection Status: Trying to Host"
	if not Lobby.create_game():
		not_connected_hbox.show()
		status_label.text = "Connection Status: Failed to Host"
	else:
		host_hbox.show()
		status_label.text = "Connection Status: Hosting!"


func _on_join_button_pressed() -> void:
	not_connected_hbox.hide()
	status_label.text = "Connection Status: Connecting..."
	if ip_line_edit:
		Lobby.join_game(ip_line_edit.text)

func _on_start_button_pressed() -> void:
	hide_menu.rpc()
	change_level.call_deferred(level_scene)

func change_level(scene):
	# Clear out old scene from memory
	for child in level_container.get_children():
		level_container.remove_child(child)
		child.queue_free()
	
	# Load in new scene
	level_container.add_child(scene.instantiate())

func _on_exit_lobby_button_pressed() -> void:
	print("Exit Lobby Menu Button Pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	
### Helper Functions ###
func _on_connection_failed():
	status_label.text = "Connection Status: Failed to Connect"
	not_connected_hbox.show()
	
func _on_connected_to_server():
	status_label.text = "Connection Status: Connected!"

### RPCS ###
@rpc("call_local", "authority", "reliable")
func hide_menu():
	ui.hide()
