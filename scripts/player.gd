extends CharacterBody2D

@onready var game = $"../.."
@onready var collision = $CollisionShape2D
@onready var joystick = $PlayerCamera/Joystick
@onready var player_camera = $PlayerCamera

#@export var joystick: PackedScene
#@export var player_camera: PackedScene

var owner_id = 1
#var camera_instance
#var joystick_instance
var SCREEN_SIZE
const PLAYER_SPEED: int = 200

func _enter_tree() -> void:
	SCREEN_SIZE = get_viewport_rect().size
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)
	if owner_id != multiplayer.get_unique_id():
		return
		
	#camera_instance = player_camera.instantiate()
	#get_tree().current_scene.add_child.call_deferred(camera_instance)
	#
	#joystick_instance = joystick.instantiate()
	#get_tree().current_scene.add_child.call_deferred(joystick_instance)

func _physics_process(delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
		
	#var s_dir = joystick_instance.scaled_direction
	var s_dir = joystick.scaled_direction
	
	if s_dir:
		velocity = s_dir * PLAYER_SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	# TODO this isn't really doing what I want player is still
	# a good distance from the screen when walking
	# we might delete this as the ship won't be as big as the screen though
	# so I am not worrying too much about that now
	var radius = collision.shape.radius
	var height = collision.shape.height
	var half_size = Vector2(radius, height)
	var sprite_frames = $AnimatedSprite2D.sprite_frames
	var texture = sprite_frames.get_frame_texture("walk", 0)
	var texture_size = texture.get_size()
	var sprite_size = texture_size * $AnimatedSprite2D.get_scale()
	position = position.clamp(sprite_size / 2, SCREEN_SIZE - sprite_size / 2)
	
func _process(delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
		
	# Have the HUD follow the player
	#camera_instance.global_position.x = global_position.x
	#camera_instance.global_position.y = global_position.y
	#
	#joystick_instance.global_position.x = global_position.x - (SCREEN_SIZE.x / 5)
	#joystick_instance.global_position.y = global_position.y + (SCREEN_SIZE.y / 7)

	if abs(velocity.x) > abs(velocity.y):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif abs(velocity.y) > abs(velocity.x):
		if (velocity.y > 0):
			$AnimatedSprite2D.animation = "down"
		else:
			$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_h = false
	if velocity:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
