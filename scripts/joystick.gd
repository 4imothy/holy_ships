extends Node2D

var scaled_direction: Vector2
var MAX_DRAG_DISTANCE: float
var DEAD_ZONE: float

@onready var knob = $knob
@onready var ring = $ring

var touch_pos: Vector2

func _ready() -> void:
	var ring_size = ring.texture.get_size()
	MAX_DRAG_DISTANCE = ring_size.x * ring.scale.x / 3
	DEAD_ZONE = MAX_DRAG_DISTANCE / 7
	
func _process(delta: float):
	scaled_direction = _scaled_direction($TouchScreenButton.is_pressed(), 
											  touch_pos, delta)
	
func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $TouchScreenButton.is_pressed():
			touch_pos = make_input_local(event).position

func _scaled_direction(pressing: bool, touch_pos: Vector2, delta: float) -> Vector2:
	if pressing:
		if touch_pos.length() <= MAX_DRAG_DISTANCE:
			knob.position = touch_pos
		else:
			var angle = touch_pos.angle()
			knob.position.x = cos(angle) * MAX_DRAG_DISTANCE
			knob.position.y = sin(angle) * MAX_DRAG_DISTANCE
		return calc_scaled_direction()
	else:
		knob.position = lerp(knob.position, Vector2(0,0), 
							   delta * MAX_DRAG_DISTANCE / 10)
		return Vector2(0,0)

func calc_scaled_direction() -> Vector2:
	var dif = knob.global_position.x - global_position.x
	var s_dir: Vector2
	var dist = abs(dif) 
	if dist >= DEAD_ZONE:
		s_dir.x = dif / MAX_DRAG_DISTANCE
	dif = knob.global_position.y - global_position.y
	dist = abs(dif)
	if dist >= DEAD_ZONE:
		s_dir.y = dif / MAX_DRAG_DISTANCE
	return s_dir
