extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

# Define the two colors to alternate between
var color1 = Color(1, 1, 0, 1)
var color2 = Color(1, 0, 0, 1)
var is_color1 = true  # Track the current color

var is_server = false

func _ready() -> void:
	is_server = multiplayer.is_server()
	SignalBus.apply_shake.connect(apply_shake)
	$WaterTask.visible = false


func _play_alert_sound() -> void:
	if is_server:  # Ensure only the server emits the signal
		print("Emitting alert_player signal from the server")
		SignalBus.alert_player.emit()

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
