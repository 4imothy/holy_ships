extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0

@onready var timer = $Timer
@onready var label = $FireMessage

func find_fire_node() -> Node2D:
	var fires = get_tree().get_nodes_in_group("Fire")
	return fires[0]
	
@onready var fire = find_fire_node()


var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0
var is_server = false
# Define the two colors to alternate between
var color1 = Color(1, 1, 0, 1)
var color2 = Color(1, 0, 0, 1)
# Track the current color
var is_color1 = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.apply_shake.connect(apply_shake)
	$WaterTask.visible = false
	fire.connect("visibility_changed", Callable(self, "_on_fire_visibility_changed"))
	
	_on_fire_visibility_changed()
	
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer.start()
	label.modulate = color1

func _on_fire_visibility_changed() -> void:
	# Sync FireMessage visibility with Fire visibility
	label.visible = fire.visible

func _on_Timer_timeout():
	# Toggle the color
	if is_color1:
		label.modulate = color2
	else:
		label.modulate = color1
	is_color1 = !is_color1

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
