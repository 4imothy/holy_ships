extends Node2D

@onready var water_bucket = $WaterBucket
@onready var button = $Button

func _ready():
	# Connect the button's signals to start and stop the animation
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)

	# Connect the "animation_finished" signal of the AnimatedSprite2D
	water_bucket.animation_finished.connect(_on_animation_finished)

	# Ensure the animation is paused at the start
	water_bucket.play()
	water_bucket.stop()  # Switching to stop after play to set the initial frame correctly

func _on_button_down():
	# Resume playing the animation from the current frame when the button is held down
	water_bucket.play()

func _on_button_up():
	# Pause the animation when the button is released
	water_bucket.stop()

func _on_animation_finished():
	# Print message when animation is done
	print("Animation done")
