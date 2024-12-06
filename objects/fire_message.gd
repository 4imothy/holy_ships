extends Label

@export var alert_interval: float = 3.0 
@onready var timer = $Timer

var color1 = Color(1, 1, 0, 1)
var color2 = Color(1, 0, 0, 1)
var is_color1 = true 

var is_server = false
	
func set_warning_text(mes):
	print('here')
	text = mes
	timer.connect("timeout", Callable(self, "_play_alert_sound"))
	
	if is_server:
		timer.start()
	
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer.start()
	modulate = color1

func _ready() -> void:	
	SignalBus.set_warning_text.connect(set_warning_text)
	timer.wait_time = alert_interval
	timer.one_shot = false

func _play_alert_sound() -> void:
	if is_server:  # Ensure only the server emits the signal
		print("Emitting alert_player signal from the server")
		SignalBus.alert_player.emit()

func _on_Timer_timeout():
	# Toggle the color
	if is_color1:
		modulate = color2
	else:
		modulate = color1
	is_color1 = !is_color1
