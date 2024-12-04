extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0
var is_server = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.apply_shake.connect(apply_shake)

@rpc
func apply_shake():
	shake_strength = randomStrength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shake"):
		apply_shake()
		
	if shake_strength > 0: 
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
		offset = randomOffset()
		
		
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _on_apply_shake():
	if is_server:
		apply_shake.rpc()