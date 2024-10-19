extends CharacterBody2D

@onready var game = $".."
@onready var joystick = $"../Joystick"
@onready var map = $"../Map"
@onready var collision = $CollisionShape2D

func _physics_process(delta: float) -> void:
	var s_dir = joystick.scaled_direction
	if s_dir:
		velocity = s_dir * game.PLAYER_SPEED
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
	position = position.clamp(sprite_size / 2, game.SCREEN_SIZE - sprite_size / 2)

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
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
