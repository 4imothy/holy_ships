extends Node2D

@export var label: Label

func set_text(text: String) -> void:
	label.text = text
	
func set_gate(number: int) -> void:
	label.text = 'Gate ' + str(number)
