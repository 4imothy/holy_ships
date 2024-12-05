extends Node2D

var is_full = false  # Tracks whether the bucket is full

func _ready() -> void:
	$AnimatedSprite2D.animation = "empty"
	print("Water bucket ready")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if is_full:
			print("The water bucket is already full. Task cannot be accessed.")
			#_show_full_bucket(body)
		else:
			print("Player has touched the water bucket!")
			_show_water_task(body)

func _show_water_task(player: Node2D) -> void:
	var ui_node = player.camera
	if ui_node:
		var water_task = ui_node.get_node("WaterTask")  # Access WaterTask within the UI
		if water_task and water_task is Node2D:
			if water_task.get("is_complete"):
				water_task.set("is_complete", false)  # Reset task completion status
				print("WaterTask reset for new interaction.")
				_reset_water_task_animation(water_task)  # Reset the animation to the first frame
			water_task.visible = true
			_monitor_task_completion(water_task, player)

func _monitor_task_completion(water_task: Node2D, player: Node2D) -> void:
	# Continuously check for task completion
	var task_timer = Timer.new()
	add_child(task_timer)
	task_timer.wait_time = 0.1
	task_timer.one_shot = false
	task_timer.start()

	task_timer.timeout.connect(func() -> void:
		if water_task.get("is_complete"):
			water_task.visible = false
			#$AnimatedSprite2D.animation = "full"
			is_full = true
			print("WaterTask is complete. Bucket is now full.")
			_show_full_bucket(player)
			task_timer.queue_free()
	)

func _reset_water_task_animation(water_task: Node2D) -> void:
	var animated_sprite = water_task.get_node("WaterBucket")
	if animated_sprite and animated_sprite is AnimatedSprite2D:
		animated_sprite.stop() 
		animated_sprite.frame = 0 
		print("WaterTask animation reset to the first frame.")

func _show_full_bucket(player: Node2D) -> void:
	var full_bucket_sprite = player.get_node("FullBucket")
	if full_bucket_sprite and full_bucket_sprite is Node2D:
		full_bucket_sprite.visible = true

func set_to_empty() -> void:
	$AnimatedSprite2D.animation = "empty"
	is_full = false  # Reset the bucket's state
