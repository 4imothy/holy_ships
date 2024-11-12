extends Area2D

const PIXEL_DIM = 64
var player_count = 0
@export var sprite: Sprite2D
@export var pp_label: Label
@export var opens_door: bool
@export var part_of_puzzle: bool
@onready var parent = $'..'

func _ready() -> void:
	assert(not(opens_door and part_of_puzzle))
	assert(opens_door or part_of_puzzle)
	pp_label.text = name.right(1)
	if opens_door:
		parent = $'..'
		parent.set_number(name.right(1))

func shift_sprite_region(direction: int) -> void:
	pp_label.position.y += direction * 4
	sprite.region_rect.position.x += direction * PIXEL_DIM

func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group('feet'):
		return
	if player_count == 0:
		if opens_door:
			parent.open()
		if part_of_puzzle:
			parent.stepped_on(name)
		shift_sprite_region(1)
	player_count += 1

func _on_area_exited(area: Area2D) -> void:
	if !area.is_in_group('feet'):
		return
	player_count -= 1
	if player_count == 0:
		if opens_door:
			parent.close()
		shift_sprite_region(-1)
