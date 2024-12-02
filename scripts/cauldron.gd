extends Node2D

@export var player_group: String = "Player"  # Group to identify players

var deposited_items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(multiplayer.get_unique_id(), deposited_items)
	pass

func _on_dropping_area_area_entered(body: Area2D) -> void:
	var player_node = body.get_parent()
	
	if player_node.is_in_group(player_group):
		if player_node.multiplayer.get_unique_id() == player_node.get_multiplayer_authority():
			print("Player entered zone with sprite:", player_node.chosen_sprite)
			append_to_list(player_node.chosen_sprite)
			if player_node.has_method("toggle_off_chosen_sprite"):
				player_node.toggle_off_chosen_sprite()
				
@rpc("any_peer")  # RPC that all players can call
func append_to_list(sprite: String) -> void:
	deposited_items.append(sprite)
	print("Updated deposited_items:", deposited_items)
	rpc("deposited_items", deposited_items)  # Sync list to all players
		
@rpc("any_peer")
func sync_my_list(updated_list: Array) -> void:
	deposited_items = updated_list
	print("Synchronized deposited_items:", deposited_items)
