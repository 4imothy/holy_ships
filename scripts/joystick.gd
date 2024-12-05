extends Node2D

var max_drag_distance: float
var dead_zone: float

@onready var knob = $knob
@onready var ring = $ring

var touch_pos: Vector2

func _ready() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var joystick_size = ring.texture.get_size() 
	var padding = 20 
	position = Vector2(
		- viewport_size.x / 6,
		viewport_size.y / 8,
	)
	var ring_size = ring.texture.get_size()
	max_drag_distance = ring_size.x * ring.scale.x / 3
	dead_zone = max_drag_distance / 7
	
func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $TouchScreenButton.is_pressed():
			touch_pos = make_input_local(event).position

func scaled_direction(delta: float) -> Vector2:
	if $TouchScreenButton.is_pressed():
		if touch_pos.length() <= max_drag_distance:
			knob.position = touch_pos
		else:
			var angle = touch_pos.angle()
			knob.position.x = cos(angle) * max_drag_distance
			knob.position.y = sin(angle) * max_drag_distance
		return calc_scaled_direction()
	else:
		knob.position = lerp(knob.position, Vector2(0,0), 
							   delta * max_drag_distance / 10)
		return Vector2(0,0)

func calc_scaled_direction() -> Vector2:
	var s_dir: Vector2
	var dif = knob.position.x
	var dist = abs(dif) 
	if dist >= dead_zone:
		s_dir.x = dif / max_drag_distance
	dif = knob.position.y
	dist = abs(dif)
	if dist >= dead_zone:
		s_dir.y = dif / max_drag_distance
	return s_dir
	
func calc_scaled_direction_4d() -> Vector2:
	var s_dir := Vector2.ZERO
	var dif = knob.global_position - global_position
	var dist  = abs(dif)

	if dist.x >= dead_zone and dist.x > dist.y:
		s_dir.x = sign(dif.x) * (dist.x / max_drag_distance)
	elif dist.y >= dead_zone and dist.y > dist.x:
		s_dir.y = sign(dif.y) * (dist.y / max_drag_distance)
	
	return s_dir
