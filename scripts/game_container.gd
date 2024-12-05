extends Node2D

@export var game: PackedScene
@export var end_game_video: PackedScene


func _ready() -> void:
	SignalBus.end_game.connect(end_game)
	if multiplayer.is_server():
		add_child(game.instantiate())
		
@rpc('any_peer', 'reliable')	
func end_game_fr(success: bool) -> void:
	var ender = end_game_video.instantiate()
	queue_free()
	get_tree().root.add_child(ender)
	ender.end_game(success)
	if multiplayer.is_server():
		Lobby.stop_game()
	else:
		end_game_fr.rpc(success) # to server


func end_game(success: bool) -> void:
	if multiplayer.is_server():
		end_game_fr.rpc(success) # host calls peer, peer calls host, host ends game
