extends Control

@export var beeper: AudioStreamPlayer2D
@export var main_menu_music: AudioStreamPlayer2D

@export var options_menu: PackedScene
@export var lobby_menu: PackedScene
@export var game_container: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu_music.play()

func start_game():
	swap_to_level_container.rpc()

@rpc("call_local", "authority", "reliable")
func swap_to_level_container():
	get_tree().root.add_child(game_container.instantiate())
	queue_free()
	
func _on_start_button_pressed() -> void:
	var lobby = lobby_menu.instantiate()
	lobby.beeper = beeper
	add_child(lobby)

func _on_options_button_pressed() -> void:
	var options = options_menu.instantiate()
	options.beeper = beeper
	add_child(options)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_texture_rect_mouse_entered() -> void:
	beeper.play()
