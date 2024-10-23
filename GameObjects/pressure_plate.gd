extends Area2D

const PIXEL_DIM = 64
var player_count = 0
@onready var sprite = $Sprite2D

func shift_sprite_region(offset_x: int) -> void:
	var region = sprite.region_rect
	region.position.x += offset_x
	sprite.region_rect = region

func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group('feet'):
		return
	if player_count == 0:
		shift_sprite_region(PIXEL_DIM)
	player_count += 1

func _on_area_exited(area: Area2D) -> void:
	if !area.is_in_group('feet'):
		return
	player_count -= 1
	if player_count == 0:
		shift_sprite_region(-PIXEL_DIM)
