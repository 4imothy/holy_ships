extends Node

#@export var ip_line_edit: LineEdit
@export var status_label: Label
@export var not_connected_hbox: HBoxContainer
@export var host_hbox: HBoxContainer

@onready var main_menu = $".."

var beeper = null
var ip_line_edit = "127.0.0.1"

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
		Lobby.join_game(ip_line_edit)

func _on_start_button_pressed() -> void:
	main_menu.start_game()

func _on_exit_lobby_button_pressed() -> void:
	beeper.play()
	queue_free()
	
### Helper Functions ###
func _on_connection_failed():
	status_label.text = "Connection Status: Failed to Connect"
	not_connected_hbox.show()
	
func _on_connected_to_server():
	status_label.text = "Connection Status: Connected!"
	
# TODO change all buttons to touchscreen buttons 
# no hovering on mobile phones so remove that
func _on_texture_rect_mouse_entered() -> void:
	beeper.play()
