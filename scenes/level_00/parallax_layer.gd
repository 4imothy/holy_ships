extends ParallaxLayer

@export var layer_speed = 5

func _process(delta):
	motion_offset.x -= layer_speed * delta
