extends Node

@export var pp_stepped_player: AudioStreamPlayer2D
@export var pp_release_player: AudioStreamPlayer2D

var is_server = false

func _ready():
	# Register Subscribers
	if multiplayer.is_server():
		is_server = true
		SignalBus.pp_step.connect(play_stepped_sound)
		SignalBus.pp_release.connect(play_released_sound)
		
	SignalBus.pp_step.connect(_on_pp_stepped)
	SignalBus.pp_release.connect(_on_pp_released)
	
@rpc
func play_stepped_sound():
	pp_stepped_player.play()

@rpc
func play_released_sound():
	pp_release_player.play()

func _on_pp_stepped():
	if is_server:
		play_stepped_sound.rpc()

func _on_pp_released():
	if is_server:
		play_released_sound.rpc()
		
