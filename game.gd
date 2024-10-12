extends Node2D

const PLAYER_SPEED: int = 200
var SCREEN_SIZE: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SCREEN_SIZE = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
