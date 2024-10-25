# MusicManager.gd (Singleton)
extends AudioStreamPlayer2D

const main_menu_music = preload("res://Assets/sound/main_menu_music_hs.mp3")

func play_music(music: AudioStream, volume = -10.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_main_menu_music():
	play_music(main_menu_music)
	
func stop_music():
	stop()
	
