extends Area2D

@export var rdoor_label: Label
@export var rdoor: Sprite2D
@export var ldoor: Sprite2D
@export var exit: Node2D

var open_door = false
var close_door = false
var rdoor_open = false
var ldoor_open = false
var door_open = false
const door_speed: float = 100.0
var target_offset: float = 20

var left_exit = false

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
	close_door = true

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
			open_door = false
			door_open = true
	elif close_door:
		if rdoor.position.x > rdoor_original_position.x:
			rdoor.position.x -= door_speed * delta
		else:
			rdoor_open = false
		if ldoor.position.x < ldoor_original_position.x:
			ldoor.position.x += door_speed * delta
		else: 
			ldoor_open = false
		if not ldoor_open and not rdoor_open:
			rdoor.position = rdoor_original_position
			ldoor.position = ldoor_original_position
			close_door = false
		door_open = false


func _on_area_entered(area: Area2D) -> void:
	if !door_open or !area.is_in_group('feet'):
		return
	left_exit = false
	area.get_parent().global_position = exit.global_position


func _on_exit_area_entered(area: Area2D) -> void:
	if !left_exit or !door_open or !area.is_in_group('feet'):
		return
	area.get_parent().global_position = Vector2(global_position.x, global_position.y + 32)


func _on_exit_area_exited(area: Area2D) -> void:
	left_exit = true
