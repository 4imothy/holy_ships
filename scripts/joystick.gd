extends Node2D

var scaled_direction: Vector2
var MAX_DRAG_DISTANCE: float
var DEAD_ZONE: float

@onready var knob = $knob

var holding_finger_pos: Vector2

func _ready() -> void:
	var ring = $ring
	var ring_size = ring.texture.get_size()
	MAX_DRAG_DISTANCE = (ring_size.x * ring.scale.x) / 4
	DEAD_ZONE = MAX_DRAG_DISTANCE / 7
	
func _process(delta: float):
	scaled_direction = knob.scaled_direction($TouchScreenButton.is_pressed(), 
											 holding_finger_pos, delta)
	
func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $TouchScreenButton.is_pressed():
			holding_finger_pos = event.position
			
