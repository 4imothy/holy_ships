extends CharacterBody2D

@export var UI: PackedScene

# For Player
var owner_id
var camera
var joystick
const PLAYER_SPEED: int = 7000

# For Inventory
@onready var CurrentItemHolder = $CurrentItem
@onready var items = $CurrentItem.get_children()
@onready var bucket = $FullBucket
var item_sprites = []
var chosen_sprite: String = "" 

func _enter_tree() -> void:
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)
	if owner_id != multiplayer.get_unique_id():
		return
	
	camera = UI.instantiate()
	joystick = camera.get_node("Joystick")
	add_child(camera)

func _ready() -> void:
	# Light Weight Inventory Set Up (Vending, Buckets)
	for item in items:
		if item is Sprite2D:
			item.visible = false
			item_sprites.append(item)
	$Feet.add_to_group('feet')
	return
	# this shader stuff doesn't look very good
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://GameObjects/player.gdshader")
	shader_material.set_shader_parameter("tint_color", Color(0.0, 0.0, 1.0))
	# this doesn't properly set the value in the shader I think but can
	# worry about that if we actually want to use this method to tint
	$AnimatedSprite2D.material = shader_material

func _physics_process(delta: float) -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
		
	var s_dir = joystick.scaled_direction(delta) * delta
	if s_dir:
		velocity = s_dir * PLAYER_SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	global_position = global_position.round()
	
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
		
func toggle_random_item_on() -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
		
	# Set all to inactive first
	for sprite in item_sprites:
		sprite.visible = false

	# Select a random sprite and make it visible
	if item_sprites.size() > 0:
		var random_sprite = item_sprites[randi() % item_sprites.size()]
		random_sprite.visible = true
		chosen_sprite = random_sprite.name

func toggle_off_chosen_sprite() -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
		
	for sprite in item_sprites:
		sprite.visible = false
	
	chosen_sprite = ""

func toggle_bucket_on() -> void:
	if multiplayer.multiplayer_peer == null:
		return
	if owner_id != multiplayer.get_unique_id():
		return
	bucket.visible = true
	
		
	
