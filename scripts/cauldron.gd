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

# Off shows empty cauldron, On shows what CAULDRON_STATE is active
@onready var CAULDRON_FILL_TOGGLE = $Sprite2D/OnStates

@onready var CAULDRON_STATES = [
	$"Sprite2D/OnStates/Filled Blue",	# Water Bottle
	$"Sprite2D/OnStates/Filled Red",	# Coke Bottle
	$"Sprite2D/OnStates/Filled Orange", # Tea Bottle
	$"Sprite2D/OnStates/Filled Purple",	# Puzzle Complete
	$"Sprite2D/OnStates/Filled Green",  # When an item is placed in that has no matches
]

# Bottle options
const BOTTLE_OPTIONS = ["WaterBottle", "CokeBottle", "TeaBottle"]

var deposited_items = []  # List of deposited items by players
var slot_choices = []  # Holds the random bottle choice for each slot
var cauldron_complete = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Only the server initializes the slots
	if multiplayer.is_server():
		call_deferred("initialize_slots")
	
	# Initially hide all cauldron states
	for state in CAULDRON_STATES:
		state.visible = false
	CAULDRON_FILL_TOGGLE.visible = false

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
	rpc("sync_slot_choices", slot_choices)

@rpc("any_peer")
func update_cauldron_state(sprite: String) -> void:
	# Show the corresponding cauldron state based on the sprite
	var state_index = BOTTLE_OPTIONS.find(sprite)
	if state_index >= 0 and state_index < CAULDRON_STATES.size():
		CAULDRON_FILL_TOGGLE.visible = true
		for i in range(CAULDRON_STATES.size()):
			CAULDRON_STATES[i].visible = (i == state_index)
	
@rpc("any_peer", "call_remote")
func sync_slot_choices(choices: Array) -> void:
	# ONLY RUNS ON PEER (NOT HOST SERVER)
	slot_choices = choices # Sync the lists to be the same
	
	# Adjust visibility for all players
	for i in range(SLOT_PATHS.size()):
		var slot = SLOT_PATHS[i]
		var chosen_bottle = slot_choices[i]
		for bottle in BOTTLE_OPTIONS:
			slot.get_node(bottle).visible = (bottle == chosen_bottle)
		slot.get_node("CheckSymbol").visible = false

func _on_dropping_area_area_entered(body: Area2D) -> void:
	if not cauldron_complete:
		var player_node = body.get_parent()
		
		if player_node.is_in_group(player_group):
			if player_node.multiplayer.get_unique_id() == player_node.get_multiplayer_authority():
				if player_node.chosen_sprite != "":
					append_to_list(player_node.chosen_sprite)
					if player_node.has_method("toggle_off_chosen_sprite"):
						player_node.toggle_off_chosen_sprite()
	else:
		var player_node = body.get_parent()
		if player_node.is_in_group(player_group):
			if player_node.multiplayer.get_unique_id() == player_node.get_multiplayer_authority():
				if player_node.chosen_sprite != "":
					if player_node.has_method("toggle_off_chosen_sprite"):
						player_node.toggle_off_chosen_sprite()
				
@rpc("any_peer")  # RPC that all players can call
func append_to_list(sprite: String) -> void:
	deposited_items.append(sprite)
	rpc("sync_my_list", deposited_items)  # Sync list to all players
	
	# Update the color based on what was thrown in
	update_cauldron_state(sprite)
	rpc("update_cauldron_state", sprite)
	
	# Check for a match
	check_for_matches(sprite)
	rpc("check_for_matches", sprite)
	
		
@rpc("any_peer")
func sync_my_list(updated_list: Array) -> void:
	deposited_items = updated_list

@rpc("any_peer")
func check_for_matches(sprite: String) -> void:
	var no_matches = true
	# Toggle Cauldron Visibility
	for i in range(SLOT_PATHS.size()):
		var slot = SLOT_PATHS[i]
		if slot_choices[i] == sprite and not slot.get_node("CheckSymbol").visible:
			no_matches = false
			slot.get_node("CheckSymbol").visible = true
			print("Slot", i + 1, "matched with", sprite)
			break
			
	# Incorrect Color
	if no_matches:
		CAULDRON_FILL_TOGGLE.visible = true
		CAULDRON_STATES[CAULDRON_STATES.size() - 1].visible = true

	# Check if all slots are matched
	var all_matched = true
	for slot in SLOT_PATHS:
		if not slot.get_node("CheckSymbol").visible:
			all_matched = false
			break

	if all_matched:
		print("All slots matched! Minigame complete.")
		cauldron_complete = true
		CAULDRON_FILL_TOGGLE.visible = true
		CAULDRON_STATES[CAULDRON_STATES.size() - 2].visible = true
		# Trigger minigame completion logic here ALL 
		# (PLAYERS GET HERE AND RUN THIS)
