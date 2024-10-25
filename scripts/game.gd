extends Node2D

@export var player_scene: PackedScene
@export var players_container: Node2D
@export var spawn_points: Array[Node2D]

@onready var music_player = $"---Environment---/BackgroundMusic"

const PLAYER_SPEED: int = 300
var next_spawn_point_index = 0
var music_started = false  # Track if music has started

func _ready() -> void:
	if not multiplayer.is_server():
		return
	elif multiplayer.is_server():
		# Listeners (Subscribe to Events)
		multiplayer.peer_connected.connect(add_player) # Added for late joiners (not sure how it works)
		multiplayer.peer_disconnected.connect(delete_player)
		
		for id in multiplayer.get_peers():
			add_player(id)
			
		add_player(1)
		
		# Start music on the server
		_start_music()

func _process(delta):
	if multiplayer.is_server() and music_started:
		# Periodically send the music state to keep things in sync
		rpc("sync_music", music_player.get_playback_position())
		
func _exit_tree(): # Built in Function
	if multiplayer.multiplayer_peer == null:
		return
	
	if not multiplayer.is_server():
		return
		
	# Unsubscribe from Events
	multiplayer.peer_disconnected.connect(delete_player)

### Player Management Functions ###
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

### Music Synchronization Functions ###
func _start_music():
	# Only start the music on the server
	if multiplayer.is_server():
		music_player.play()
		music_started = true
		# Broadcast the music state to all clients
		rpc("sync_music", music_player.get_playback_position())
		print("Server started music, broadcasting to clients")

@rpc("any_peer", "reliable")
func sync_music(position):
	# If the music is playing but the position is off, adjust it
	if music_player.is_playing():
		var current_position = music_player.get_playback_position()
		# Allow a small tolerance for position differences to avoid unnecessary seeks
		if abs(current_position - position) > .6:
			music_player.seek(position)
	else:
		# If the music is not playing, start it at the correct position
		music_player.play(position)

func _sync_music_with_client(client_id):
	# Send current music state to the specific client
	var music_position = music_player.get_playback_position()
	rpc_id(client_id, "sync_music", music_position)
	print("Server sent music sync to client", client_id, "at position:", music_position)
