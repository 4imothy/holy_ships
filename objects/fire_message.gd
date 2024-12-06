extends Label

@export var alert_interval: float = 3.0 
@onready var timer = $Timer

var color1 = Color(1, 1, 0, 1)
var color2 = Color(1, 0, 0, 1)
var is_color1 = true 

var is_server = false
	
func set_warning_text(mes):
	text = mes
	_play_alert_sound()
	timer.start()
	modulate = color1
	
func stop_warning_text():
	text = ''
	timer.stop()

func _ready() -> void:	
	is_server = multiplayer.get_unique_id() == Lobby.HOST_ID
	SignalBus.set_warning_text.connect(set_warning_text)
	SignalBus.stop_warning_text.connect(stop_warning_text)
	timer.wait_time = alert_interval
	timer.one_shot = false
	timer.timeout.connect(_on_Timer_timeout)
	timer.timeout.connect(_play_alert_sound)

func _play_alert_sound() -> void:
	SignalBus.alert_player.emit()

func _on_Timer_timeout():
	if is_color1:
		modulate = color2
	else:
		modulate = color1
	is_color1 = !is_color1
