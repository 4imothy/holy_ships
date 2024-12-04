extends Control

var beeper = null
var main_menu_music: AudioStreamPlayer2D

func _ready() -> void:
	# Initialize slider to the current volume of main_menu_music
	if main_menu_music:
		$VBoxContainer/Volume.min_value = -80  
		$VBoxContainer/Volume.max_value = 0
		$VBoxContainer/Volume.value = main_menu_music.volume_db
		
func _on_exit_options_button_pressed() -> void:
	queue_free()

func _on_texture_rect_mouse_entered() -> void:
	beeper.play()
	
# Called when the slider value changes
func _on_volume_value_changed(value: float) -> void:
	if main_menu_music:
		main_menu_music.volume_db = value / 5


# Called when the mute checkbox is toggled
func _on_mute_toggled(toggled_on: bool) -> void:
	if main_menu_music:
		if toggled_on:
			main_menu_music.volume_db = -80  # Mute the audio
		else:
			main_menu_music.volume_db = $VBoxContainer/Volume.value 
