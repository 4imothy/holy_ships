extends Node2D

@onready var water_bucket = $WaterBucket
@onready var button = $Button

var is_complete = false

func _ready():
	# Connect the button's signals to start and stop the animation
	is_complete = false
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)

	# Connect the "animation_finished" signal of the AnimatedSprite2D
	water_bucket.animation_finished.connect(_on_animation_finished)

func _on_button_down():
	water_bucket.play()

func _on_button_up():
	water_bucket.pause()

func _on_animation_finished():
	print("Animation done")
	is_complete = true
