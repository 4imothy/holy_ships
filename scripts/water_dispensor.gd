extends CharacterBody2D

@onready var decrement_timer = Timer.new() 
@onready var isComplete = false;

@onready var computer = $'../Computer'

func set_text() -> void:
	SignalBus.set_warning_text.emit('Fire Started!')

func _ready() -> void:
	decrement_timer.one_shot = false
	set_text.call_deferred()
	computer.set_gate(3)
	decrement_timer.wait_time = 3.0  # Decrement health every 2 seconds
	decrement_timer.connect("timeout", Callable(self, "_decrement_health").bind(8))
	add_child(decrement_timer)
	decrement_timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var full_bucket_sprite = body.get_node("FullBucket")
		if full_bucket_sprite.visible:
			set_full_bucket_visibility(body, false)
			
			# Access the fire sprite and water bucket
			var game_node = get_parent()
			if game_node:
				var fire_sprite = game_node.get_node("Fire")
				if fire_sprite:
					set_fire_visibility(false)
					rpc("set_fire_visibility", false)
					print('fire vis is false')
					SignalBus.fire_put_out.emit()
					print('computer setting done')
					computer.set_done()
				var bucket = game_node.get_node("WaterBucket")
				if bucket:
					bucket.is_full = false
					
					var animated_sprite = bucket.get_node("AnimatedSprite2D")
					if animated_sprite:
						animated_sprite.animation = "empty"
					
		else:
			print("No FullBucket visible on this player.")

# RPC method to update the fire's visibility
@rpc("any_peer")
func set_fire_visibility(visible: bool):
	var game_node = get_parent()
	if game_node:
		var fire_sprite = game_node.get_node("Fire")
		if fire_sprite:
			fire_sprite.visible = visible
			print("Fire visibility set to:", visible)

func set_full_bucket_visibility(body: Node2D, is_visible: bool) -> void:
	if body:
		var full_bucket_sprite = body.get_node("FullBucket")
		if full_bucket_sprite:
			full_bucket_sprite.visible = is_visible
			
func _decrement_health(amount_to_decrease: int) -> void:
	var game_node = get_parent()
	if game_node:
		var fire_sprite = game_node.get_node("Fire")
		if fire_sprite.visible == true and multiplayer.is_server():
			SignalBus.decrease_health.emit(amount_to_decrease)

	
