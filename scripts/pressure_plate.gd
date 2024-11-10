extends Area2D

const PIXEL_DIM = 64
var player_count = 0
@export var sprite: Sprite2D
@export var pp_label: Label
@export var door: Node2D

func _ready() -> void:
	pp_label.text = name.right(1)
	door.set_number(name.right(1))

func shift_sprite_region(direction: int) -> void:
	pp_label.position.y += direction * 4
	sprite.region_rect.position.x += direction * PIXEL_DIM

func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group('feet'):
		return
	if player_count == 0:
		door.open()
		shift_sprite_region(1)
	player_count += 1

func _on_area_exited(area: Area2D) -> void:
	if !area.is_in_group('feet'):
		return
	player_count -= 1
	if player_count == 0:
		door.close()
		shift_sprite_region(-1)
