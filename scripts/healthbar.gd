extends Sprite2D

@onready var timer = $Timer
@onready var damage_bar = $DamageBar
@onready var health_bar = $HealthBar


var health = 0

func init_health(_health):
	health = _health
	health_bar.max_value = health
	health_bar.value = health
	damage_bar.max_value = health
	damage_bar.value - health
	
func set_health(new_health):
	var prev_health = health
	health = min(health_bar.max_value, new_health)
	health_bar.value = health
	
	if health <= 0:
		health = 0
		SignalBus.end_game.emit(false)
		return
		
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
