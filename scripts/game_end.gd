extends Control

@onready var success_video = $AspectRatioContainer/Success/Video
@onready var success_sound = $AspectRatioContainer/Success/Sound
@onready var failure_video = $AspectRatioContainer/Failure/Video
@onready var failure_sound = $AspectRatioContainer/Failure/Sound
@onready var label = $AspectRatioContainer/VBoxContainer/CenterContainer/Label

const main_menu_path = 'res://scenes/main_menu.tscn'

# TODO don't forget to stop hosting on end game
# TODO check if we have to disconnect signals I think we do but not sure
# TODO add some sound

func end_game(success: bool) -> void:
	var gc = get_node_or_null('../GameContainer')
	if gc != null:
		await(gc.tree_exited)
	if success: 
		show_success()
	else:
		show_failure()

func show_failure() -> void:
	failure_video.play()
	failure_sound.play()
	label.text = 'failure'

func show_success() -> void:
	success_video.play()
	success_sound.play()
	label.text = 'success'

func back_to_main_menu() -> void:
	var scene = ResourceLoader.load(main_menu_path)
	get_tree().root.add_child(scene.instantiate())
	queue_free()

func _on_success_video_finished() -> void:
	back_to_main_menu()
	
func _on_failure_video_finished() -> void:
	back_to_main_menu()
