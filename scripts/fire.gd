extends AnimatedSprite2D

## Duration for the reveal effect in seconds
#var reveal_duration = 5.0
#var elapsed_time = 0.0
#
## Reference to the ShaderMaterial
#@export var shader_material: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if visible and elapsed_time < reveal_duration:
		#elapsed_time += delta
		#var progress = 1.0 - min(elapsed_time / reveal_duration, 1.0)
		#if shader_material:
			#shader_material.set("shader_parameter/progress", progress)
#
#func _on_timer_timeout():
	#visible = true
	#elapsed_time = 0.0
	#if shader_material:
		#shader_material.set("shader_parameter/progress", 1.0)
