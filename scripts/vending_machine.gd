extends Node2D

@export var player_group: String = "Player"  # Group to identify players


func _on_vending_area_area_entered(body: Area2D) -> void:
	#print("Entered Vending Area")
	var player_node = body.get_parent()
	
	if player_node.is_in_group(player_group):
		if player_node.has_method("toggle_random_item"):
			player_node.toggle_random_item()
