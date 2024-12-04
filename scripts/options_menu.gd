extends Control

var beeper = null
var main_menu_music: AudioStreamPlayer2D

func _ready() -> void:
	# Initialize slider to the current volume of main_menu_music
	if main_menu_music:
		$VBoxContainer/Volume.min_value = -80  
		$VBoxContainer/Volume.max_value = 0
		$VBoxContainer/Volume.value = AudioServer.get_bus_volume_db(0)
		
func _on_exit_options_button_pressed() -> void:
	queue_free()

func _on_texture_rect_mouse_entered() -> void:
	beeper.play()
	
# Called when the slider value changes
func _on_volume_value_changed(value: float) -> void:
	if main_menu_music:
		if value < 0:
			AudioServer.set_bus_volume_db(0, value / 2)  # Set volume for bus 0
		if value == -80:
			AudioServer.set_bus_volume_db(0, -80)  # Mute the audio on bus 0
			
			


# Called when the mute checkbox is toggled
func _on_mute_toggled(toggled_on: bool) -> void:
	if main_menu_music:
		if toggled_on:
			AudioServer.set_bus_volume_db(0, -80)  # Mute audio on bus 0
		else:
			AudioServer.set_bus_volume_db(0, $VBoxContainer/Volume.value / 2)  # Set volume for bus 0 
