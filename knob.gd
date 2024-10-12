extends Sprite2D

var pressing: bool = false

@onready var joystick = $".."
var touch_id: int = -1
var touch_position: Vector2

func _ready() -> void:
	pass

# TODO make sure it works with multiple touches at the same time
func scaled_direction(pressing: bool, joystick_finger_pos: Vector2, delta: float) -> Vector2:
	if pressing:
		var mouse_pos = joystick_finger_pos # TODO rename this
		if mouse_pos.distance_to(joystick.global_position) <= joystick.MAX_DRAG_DISTANCE:
			global_position = mouse_pos
		else:
			var angle = joystick.global_position.angle_to_point(mouse_pos)
			global_position.x = joystick.global_position.x + cos(angle) * joystick.MAX_DRAG_DISTANCE
			global_position.y = joystick.global_position.y + sin(angle) * joystick.MAX_DRAG_DISTANCE
		return calc_scaled_direction()
	else:
		global_position = lerp(global_position, joystick.global_position, 
							   delta * joystick.MAX_DRAG_DISTANCE / 10)
		return Vector2(0,0)

func calc_scaled_direction() -> Vector2:
	var dif = global_position.x - joystick.global_position.x
	var s_dir: Vector2
	var dist = abs(dif) 
	if dist >= joystick.DEAD_ZONE:
		s_dir.x = dif / joystick.MAX_DRAG_DISTANCE
	dif = global_position.y - joystick.global_position.y
	dist = abs(dif)
	if dist >= joystick.DEAD_ZONE:
		s_dir.y = dif / joystick.MAX_DRAG_DISTANCE
	return s_dir
