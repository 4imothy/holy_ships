extends Node2D

@export var player_scene: PackedScene
@export var players_container: Node2D
@export var spawn_points: Array[Node2D]
@export var music_player: AudioStreamPlayer2D

@onready var healthbar = $CanvasLayer/HealthBar
@onready var decrement_timer = Timer.new()  # Create a timer instance
@onready var periodic_explosion_timer = Timer.new()
@onready var progress_timer = Timer.new() # Every time this hits 0, increment progress

var progress = 0

var next_spawn_point_index = 0
var music_started = false  # Track if music has started

var MUTE_SERVER = false
var MUTE_CLIENT = false

func _ready() -> void:
	var health = 90
	healthbar.init_health(health)
	if multiplayer.is_server() and MUTE_SERVER:
		AudioServer.set_bus_mute(0, true)
	if not multiplayer.is_server() and MUTE_CLIENT:
		AudioServer.set_bus_mute(0, true)

	if multiplayer.is_server():
		add_player(Lobby.HOST_ID)
		for id in multiplayer.get_peers():
			add_player(id)

		# Set up the timer to decrement health
		decrement_timer.one_shot = false
		decrement_timer.wait_time = 2.0  # Decrement health every 2 seconds
		decrement_timer.connect("timeout", Callable(self, "_decrement_health").bind(1))
		add_child(decrement_timer)
		decrement_timer.start()

		# Listeners (Subscribe to Events)
		multiplayer.peer_connected.connect(add_player) # Added for late joiners (not sure how it works)
		multiplayer.peer_disconnected.connect(delete_player)

		SignalBus.increase_health.connect(_increment_health)
		
		# Set up periodic sporadic explosion timer
		periodic_explosion_timer.one_shot = false
		periodic_explosion_timer.wait_time = 5
		# periodic_explosion_timer.connect("timeout", Callable(self, "_on_explosion_timeout"))
		add_child(periodic_explosion_timer)
		periodic_explosion_timer.start()
		
		# Set up progress timer
		progress_timer.one_shot = false
		progress_timer.wait_time = 35
		progress_timer.connect("timeout", Callable(self, "_on_progress_timeout"))
		add_child(progress_timer)
		progress_timer.start()
		
		### TODO: _on_progress_timeout TO INCREMENT progress INT VAR
		### TODO: progress INT VAR update moves the icon over in the bottom left corner
		### TODO: progress = 4 means we trigger the end game successfully
			### STRETCH TODO: CHANGE THE MUSIC, AND THE SPEED OF DECLINE OR SOMETHING
		### TODO: then we spit back to main menu after final cutscene, end multiplayer session
		### TODO: IF OUR DECREMENT HEALTH HITS 0 OR BELOW, WE NEED ENDGAME SCENE TO PLAY
		### TODO: then we spit back to main menu after final cutscene, end multiplayer session
		
		
		
	start_music()
	
func _on_explosion_timeout():
	periodic_explosion_timer.wait_time = int(randf_range(8, 19)) 
	emit_shake_signal()     # FOR THE SERVER 
	emit_shake_signal.rpc() # FOR THE PEER
	_decrement_health(8)

@rpc("any_peer", "reliable")
func emit_shake_signal():
	SignalBus.apply_shake.emit()

func _decrement_health(amount):
	if multiplayer.is_server():
		# Get the current health from the health bar, decrement it, and set the new value
		var current_health = healthbar.health
		var new_health = current_health - amount
		sync_health.rpc(new_health)

func _increment_health(amount):
	if multiplayer.is_server():
		# Get the current health from the health bar, decrement it, and set the new value
		var current_health = healthbar.health
		var new_health = current_health + amount
		sync_health.rpc(new_health)

@rpc("call_local", "any_peer", "reliable")
func sync_health(new_health):
	healthbar.set_health(new_health)

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
	music_player.play()
	music_started = true
