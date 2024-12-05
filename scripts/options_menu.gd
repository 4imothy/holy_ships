extends Control

var beeper = null
var main_menu_music: AudioStreamPlayer2D
var music_bus_index
var sfx_bus_index

func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("Sound Effects")
	$VBoxContainer/Music_Slider.value = AudioServer.get_bus_volume_db(music_bus_index)
	$VBoxContainer/SFX_Slider.value = AudioServer.get_bus_volume_db(sfx_bus_index)
		
func _on_exit_options_button_pressed() -> void:
	beeper.play()
	queue_free()

# Called when the mute checkbox is toggled
func _on_mute_toggled(toggled_on: bool) -> void:
	if toggled_on:
		AudioServer.set_bus_volume_db(0, -80)  # Mute audio on bus 0
	else:
		AudioServer.set_bus_volume_db(0, $VBoxContainer/Volume.value / 2)  # Set volume for bus 0 


func _on_music_slider_value_changed(value: float) -> void:
	if value < 0:
		AudioServer.set_bus_volume_db(music_bus_index, value / 2) 
	if value == -80:
		AudioServer.set_bus_volume_db(music_bus_index, -80) 


func _on_sfx_slider_value_changed(value: float) -> void:
	if value < 0:
		AudioServer.set_bus_volume_db(sfx_bus_index, value / 2) 
	if value == -80:
		AudioServer.set_bus_volume_db(sfx_bus_index, -80) 
