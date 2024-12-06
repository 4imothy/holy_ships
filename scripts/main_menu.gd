extends Control

@export var beeper: AudioStreamPlayer2D
@export var main_menu_music: AudioStreamPlayer2D

@export var options_menu: PackedScene
@export var lobby_menu: PackedScene
@export var credits: PackedScene
@export var game_container: PackedScene

const MUTE_AUDIO = false

func _init():
	if MUTE_AUDIO:
		AudioServer.set_bus_mute(0, true)

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
	beeper.play()
	var lobby = lobby_menu.instantiate()
	lobby.beeper = beeper
	add_child(lobby)

func _on_options_button_pressed() -> void:
	beeper.play()
	var options = options_menu.instantiate()
	options.beeper = beeper
	options.main_menu_music = main_menu_music
	add_child(options)

func _on_credits_button_pressed() -> void:
	beeper.play()
	var credits = credits.instantiate()
	credits.beeper = beeper
	add_child(credits)
