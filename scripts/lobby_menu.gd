extends Node

@export var status_label: Label
@export var not_connected_hbox: HBoxContainer
@export var host_hbox: HBoxContainer

@onready var main_menu = $".."

const LOCAL_HOST = '127.0.0.1'

var is_server = false
var is_client = false
var udp_server = null
var udp_client = null
var udp_server_found = false
var delta_time = 0.0
var udp_port = 6969

var beeper = null
var RUN_LOCAL = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	
func _process(delta: float) -> void:
	if is_server:
		udp_server.poll()
		if udp_server.is_connection_available():
			var udp_peer : PacketPeerUDP = udp_server.take_connection()
			var packet = udp_peer.get_packet()
			print("Recieved : %s from %s:%s" %
		   	 [
			 	packet.get_string_from_ascii(),
				udp_peer.get_packet_ip(),
				udp_peer.get_packet_port(),
			])
			var ipv4_addresses = []
			for addr in IP.get_local_addresses():
				if "." in addr and addr != LOCAL_HOST:
					ipv4_addresses.append(addr)
			var first_ipv4 = ipv4_addresses[0] if ipv4_addresses.size() > 0 else null
			if RUN_LOCAL:
				udp_peer.put_packet(LOCAL_HOST.to_utf8_buffer())
			else:
				print('sending')
				print(first_ipv4)
				udp_peer.put_packet(first_ipv4.to_utf8_buffer())
	elif is_client:
		delta_time += delta
		if delta_time >= 2.0:
			delta_time = 0.0
			if not udp_server_found:
				udp_client.put_packet("Valid Request".to_utf8_buffer())
		if udp_client.get_available_packet_count() > 0:
			udp_server_found = true
			var server_address_to_connect_to = udp_client.get_packet()
			Lobby.join_game(server_address_to_connect_to.get_string_from_utf8())


### Button Presses ###
func _on_host_button_pressed() -> void:
	beeper.play()
	not_connected_hbox.hide()
	status_label.text = "Connection Status: Trying to Host"
	if Lobby.create_game():
		host_hbox.show()
		status_label.text = "Connection Status: Hosting!"
		is_server = true
		udp_server = UDPServer.new()
		udp_server.listen(udp_port, '0.0.0.0')
	else:
		not_connected_hbox.show()
		status_label.text = "Connection Status: Failed to Host"


func _on_join_button_pressed() -> void:
	beeper.play()
	not_connected_hbox.hide()
	status_label.text = "Connection Status: Connecting..."
	is_client = true
	udp_client = PacketPeerUDP.new()
	udp_client.set_broadcast_enabled(true)
	udp_client.set_dest_address("255.255.255.255", udp_port)

func _on_start_button_pressed() -> void:
	beeper.play()
	main_menu.start_game()

func _on_exit_lobby_button_pressed() -> void:
	if is_server:
		Lobby.stop_game()
	beeper.play()
	queue_free()
	
### Helper Functions ###
func _on_connection_failed():
	status_label.text = "Connection Status: Failed to Connect"
	not_connected_hbox.show()
	
func _on_connected_to_server():
	status_label.text = "Connection Status: Connected!"
	
# TODO change all buttons to touchscreen buttons 
# no hovering on mobile phones so remove that
func _on_texture_rect_mouse_entered() -> void:
	beeper.play()
