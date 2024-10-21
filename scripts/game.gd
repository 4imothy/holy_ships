extends Node2D

@export var player_scene: PackedScene
@export var players_container: Node2D
@export var spawn_points: Array[Node2D]

const PLAYER_SPEED: int = 200
var SCREEN_SIZE: Vector2
var next_spawn_point_index = 0

func _ready() -> void:
	SCREEN_SIZE = get_viewport_rect().size
	if not multiplayer.is_server():
		return
	elif multiplayer.is_server():
		# Listeners (Subscribe to Events)
		multiplayer.peer_connected.connect(add_player) # Added for late joiners (not sure how it works)
		multiplayer.peer_disconnected.connect(delete_player)
		
		for id in multiplayer.get_peers():
			add_player(id)
			
		add_player(1)

func _exit_tree(): # Built in Function
	if multiplayer.multiplayer_peer == null:
		return
	
	if not multiplayer.is_server():
		return
		
	# Unsubscribe from Events
	multiplayer.peer_disconnected.connect(delete_player)

func add_player(id):
	var player_instance = player_scene.instantiate()
	player_instance.position = get_spawn_point()
	player_instance.name = str(id)
	players_container.add_child(player_instance)
	
func delete_player(id):
	if not players_container.has_node(str(id)):
		return
	
	players_container.get_node(str(id)).queue_free() # Remove from memory (operation is "queued")
	
func get_spawn_point():
	var spawn_point = spawn_points[next_spawn_point_index].position
	next_spawn_point_index += 1
	if next_spawn_point_index >= len(spawn_points):
		next_spawn_point_index = 0
	return spawn_point
