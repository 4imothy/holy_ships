extends Node2D

@export var player_scene: PackedScene
@export var players_container: Node2D
@export var spawn_points: Array[Node2D]

@export var music_player: AudioStreamPlayer2D

var next_spawn_point_index = 0
var music_started = false  # Track if music has started

func _ready() -> void:
	if multiplayer.is_server():
		add_player(Lobby.HOST_ID)
		for id in multiplayer.get_peers():
			add_player(id)		
		# Listeners (Subscribe to Events)			
		multiplayer.peer_connected.connect(add_player) # Added for late joiners (not sure how it works)
		multiplayer.peer_disconnected.connect(delete_player)
	start_music()
		
func _exit_tree(): # Built in Function
	if multiplayer.multiplayer_peer == null or not multiplayer.is_server():
		return
		
	# Unsubscribe from Events
	multiplayer.peer_disconnected.connect(delete_player)

### Player Management Functions ###
func add_player(id):
	var player_instance = player_scene.instantiate()
	player_instance.name = str(id)
	if id == Lobby.HOST_ID:
		player_instance.position = get_spawn_point()
	players_container.add_child(player_instance)
	
func delete_player(id):
	if not players_container.has_node(str(id)):
		return
	
	players_container.get_node(str(id)).queue_free() # Remove from memory (operation is "queued")
	
func get_spawn_point():
	var spawn_point = spawn_points[next_spawn_point_index].position
	next_spawn_point_index = (next_spawn_point_index + 1) % len(spawn_points)
	return spawn_point

func _on_multiplayer_spawner_spawned(node: Node) -> void:
	node.position = get_spawn_point()  

### Music Synchronization Functions ###
func start_music():
	if not multiplayer.is_server():
		music_player.play()
	music_started = true
