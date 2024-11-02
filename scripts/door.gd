# TODO make the door work both ways
extends Area2D

@export var rdoor_label: Label
@export var rdoor: Sprite2D
@export var ldoor: Sprite2D
@export var spawn_point: Node2D

var open_door = false
var rdoor_open = false
var ldoor_open = false
var door_open = false
const door_speed: float = 100.0
var target_offset: float = 20 

var rdoor_original_position: Vector2
var ldoor_original_position: Vector2

func _ready():
	rdoor_original_position = rdoor.position
	ldoor_original_position = ldoor.position

func set_number(number: String):
	rdoor_label.text = number

func open():
	open_door = true

func close():
	open_door = false

func _process(delta: float):
	if open_door:
		if rdoor.position.x < rdoor_original_position.x + target_offset:
			rdoor.position.x += door_speed * delta
			rdoor_open = false
		else:
			rdoor_open = true
		if ldoor.position.x > ldoor_original_position.x - target_offset:
			ldoor.position.x -= door_speed * delta
			ldoor_open = false
		else:
			ldoor_open = true
		if ldoor_open and rdoor_open:
			door_open = true
	else:
		if rdoor.position.x > rdoor_original_position.x:
			rdoor.position.x -= door_speed * delta
		if ldoor.position.x < ldoor_original_position.x:
			ldoor.position.x += door_speed * delta
		door_open = false


func _on_area_entered(area: Area2D) -> void:
	if !door_open or !area.is_in_group('feet'): 
		return
	var player = area.get_parent()
	player.global_position = spawn_point.global_position
