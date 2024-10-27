extends CharacterBody2D

@export var UI: PackedScene

var owner_id
var camera
var joystick
const PLAYER_SPEED: int = 300

func _enter_tree() -> void:
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)
	if owner_id != multiplayer.get_unique_id():
		return
	
	camera = UI.instantiate()
	joystick = camera.get_node("Joystick")
	add_child.call_deferred(camera)

func _ready() -> void:
	# this shader stuff doesn't look very good
	$Feet.add_to_group('feet')
	return
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://GameObjects/player.gdshader")
	shader_material.set_shader_parameter("tint_color", Color(0.0, 0.0, 1.0))
	# this doesn't properly set the value in the shader I think but can
	# worry about that if we actually want to use this method to tint
	$AnimatedSprite2D.material = shader_material

func _physics_process(_delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
		
	var s_dir = joystick.scaled_direction
	if s_dir:
		velocity = s_dir * PLAYER_SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func _process(_delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
	
	if abs(velocity.x) > abs(velocity.y):
		$AnimatedSprite2D.animation = 'walk'
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif abs(velocity.y) > abs(velocity.x):
		if (velocity.y > 0):
			$AnimatedSprite2D.animation = 'down'
		else:
			$AnimatedSprite2D.animation = 'up'
		$AnimatedSprite2D.flip_h = false
	if velocity:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
