extends Node2D

@export var game: PackedScene

func _ready() -> void:
	if multiplayer.is_server():
		add_child(game.instantiate())
