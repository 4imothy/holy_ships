extends Node2D

@export var player_group: String = "Player"  # Group to identify players
@export var vending_sound_player: AudioStreamPlayer2D

func _ready():
	if multiplayer.is_server():
		SignalBus.vending_sound.connect(play_vending_sound)
	
	SignalBus.vending_sound.connect(_on_vend)

func _on_vending_area_area_entered(body: Area2D) -> void:
	var player_node = body.get_parent()
	
	if player_node.is_in_group(player_group):
		print("Player entered vending area: ", player_node.name)
		SignalBus.vending_sound.emit()
		if player_node.multiplayer.get_unique_id() == player_node.get_multiplayer_authority():
			if player_node.has_method("toggle_random_item_on"):
				player_node.toggle_random_item_on()

@rpc
func play_vending_sound():
	vending_sound_player.play()

func _on_vend():
	if multiplayer.is_server():
		play_vending_sound.rpc()
