extends Node2D

@export var player_group: String = "Player"  # Group to identify players


func _on_vending_area_area_entered(body: Area2D) -> void:
	var player_node = body.get_parent()
	
	if player_node.is_in_group(player_group):
		print("Player entered vending area: ", player_node.name)
		if player_node.multiplayer.get_unique_id() == player_node.get_multiplayer_authority():
			if player_node.has_method("toggle_random_item_on"):
				player_node.toggle_random_item_on()
