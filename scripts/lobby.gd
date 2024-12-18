### lobby = Multiplayer Manager Singleton ###

extends Node

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 4587
const MAX_CONNECTIONS = 2
const HOST_ID = 1

var players = {}

var server_peer

var player_info = {"name": "Name"}

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnceted)
					
func create_game():
	server_peer = ENetMultiplayerPeer.new()
	var error = server_peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return false
	
	multiplayer.multiplayer_peer = server_peer
	
	players[HOST_ID] = player_info
	player_connected.emit(HOST_ID, player_info)
	
	return true
	
func join_game(address: String):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		print(error)
		return false
	multiplayer.multiplayer_peer = peer
	return true
	
func stop_game() -> void:
	if multiplayer.multiplayer_peer != null and server_peer != null:
		for id in multiplayer.get_peers():
			multiplayer.disconnect_peer(id)
		server_peer.close()
		multiplayer.multiplayer_peer = null
		server_peer = null
		players.clear()
		
func leave_game() -> void:
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer.close()
	
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	
@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)

func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	
func _on_connected_to_server():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
	
func _on_connection_failed():
	multiplayer.multiplayer_peer = null
	
func _on_server_disconnceted():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	
# For Debugging
#func _process(delta):
	#print(players)
