extends Control

var beeper = null
var main_menu_music: AudioStreamPlayer2D
var music_bus_index
var sfx_bus_index

var mute_pressed = false

@onready var music_slider = $VBoxContainer/Music_Slider
@onready var sfx_slider = $VBoxContainer/SFX_Slider
@onready var master_slider = $VBoxContainer/Master_Slider
@onready var mute_button = $VBoxContainer/Mute

func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("Sound Effects")
	music_slider.value = AudioServer.get_bus_volume_db(music_bus_index)
	sfx_slider.value = AudioServer.get_bus_volume_db(sfx_bus_index)
	master_slider.value = AudioServer.get_bus_volume_db(0)
		
func _on_exit_options_button_pressed() -> void:
	beeper.play()
	queue_free()

# TODO a master volume
# Called when the mute checkbox is toggled
func _on_mute_toggled(toggled_on: bool) -> void:
	if toggled_on:
		mute_pressed = true
		AudioServer.set_bus_volume_db(0, -80)  # Mute audio on bus 0
	else:
		mute_pressed = false
		AudioServer.set_bus_volume_db(0, master_slider.value / 2)  # Set volume for bus 0 

func change_value(index, value) -> void:
	if mute_pressed:
		mute_button.set_pressed_no_signal(false)
		AudioServer.set_bus_volume_db(0, master_slider.value / 2)
	if value < 0:
		AudioServer.set_bus_volume_db(index, value / 2) 
	if value == -80:
		AudioServer.set_bus_volume_db(index, -80) 
		
func _on_music_slider_value_changed(value: float) -> void:
	change_value(music_bus_index, value)

func _on_sfx_slider_value_changed(value: float) -> void:
	change_value(sfx_bus_index, value)

func _on_master_slider_value_changed(value: float) -> void:
	change_value(0, value)
