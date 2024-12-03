extends Node2D

### Local Variables ###
# Group to identify players
@export var player_group: String = "Player"  

# Slot paths
@onready var SLOT_PATHS = [
	$"Progress/CauldronScreen/Slot 1",
	$"Progress/CauldronScreen/Slot 2",
	$"Progress/CauldronScreen/Slot 3"
]
# Bottle options
const BOTTLE_OPTIONS = ["WaterBottle", "CokeBottle", "TeaBottle"]

var deposited_items = []  # List of deposited items by players
var slot_choices = []  # Holds the random bottle choice for each slot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready on peer:", multiplayer.get_unique_id())
	# Only the server initializes the slots
	if multiplayer.is_server():
		initialize_slots()

func initialize_slots() -> void:
	# Randomly assign a bottle type to each slot
	slot_choices = []
	for slot in SLOT_PATHS:
		var chosen_bottle = BOTTLE_OPTIONS[randi() % BOTTLE_OPTIONS.size()]
		slot_choices.append(chosen_bottle)
		
		# Hide all bottle types except the chosen one
		for bottle in BOTTLE_OPTIONS:
			slot.get_node(bottle).visible = (bottle == chosen_bottle)
			
		# Hide the check symbol initially
		slot.get_node("CheckSymbol").visible = false

	# Sync the choices to all clients
	#rpc("slot_choices", slot_choices)
	print(slot_choices)
	rpc("sync_slot_choices", slot_choices)
	print("WHY NO CALL")
	
@rpc("any_peer")
func sync_slot_choices(choices: Array) -> void:
	print(multiplayer.get_unique_id())
	print("asdfasdfasfdsaf")
	slot_choices = choices # Sync the lists to be the same
	
	# Adjust visibility for all players
	for i in range(SLOT_PATHS.size()):
		var slot = SLOT_PATHS[i]
		var chosen_bottle = slot_choices[i]
		for bottle in BOTTLE_OPTIONS:
			slot.get_node(bottle).visible = (bottle == chosen_bottle)
		slot.get_node("CheckSymbol").visible = false

func _on_dropping_area_area_entered(body: Area2D) -> void:
	var player_node = body.get_parent()
	
	if player_node.is_in_group(player_group):
		print(player_node.multiplayer.get_unique_id())
		print(player_node.get_multiplayer_authority())
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
	
	# Now that all players have the same list, we can check for a match
	check_for_matches(sprite)
		
@rpc("any_peer")
func sync_my_list(updated_list: Array) -> void:
	deposited_items = updated_list
	print("Synchronized deposited_items:", deposited_items)

func check_for_matches(sprite: String) -> void:
	for i in range(SLOT_PATHS.size()):
		var slot = SLOT_PATHS[i]
		if slot_choices[i] == sprite and not slot.get_node("CheckSymbol").visible:
			slot.get_node("CheckSymbol").visible = true
			print("Slot", i + 1, "matched with", sprite)
			break

	# Check if all slots are matched
	var all_matched = true
	for slot in SLOT_PATHS:
		if not slot.get_node("CheckSymbol").visible:
			all_matched = false
			break

	if all_matched:
		print("All slots matched! Minigame complete.")
		# Trigger minigame completion logic here
