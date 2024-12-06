extends Node2D

signal game_completed

@onready var computer = $'../Computer'

@onready var one = $'1'
@onready var two = $'2'
@onready var three = $'3'
@onready var four = $'4'
@onready var five = $'5'
@onready var six = $'6'
@onready var seven = $'7'
@onready var eight = $'8'
@onready var nine = $'9'

var game_entered = false
var game_started = false

var should_be_pressed: int = -1

var cur_in_a_row: int = 0
var TARGET_IN_A_ROW: int

func start_game(num_in_a_row: int) -> void:
	if multiplayer.get_unique_id() == Lobby.HOST_ID:
		TARGET_IN_A_ROW = num_in_a_row
		SignalBus.set_warning_text.emit('System Malfunction!')
		computer.set_gate(1)
		game_started = true

func stepped_on(name: String) -> void:
	if multiplayer.get_unique_id() == Lobby.HOST_ID:
		if int(name) == should_be_pressed:
			cur_in_a_row += 1
			if cur_in_a_row == TARGET_IN_A_ROW:
				computer.set_done()
				SignalBus.stop_warning_text.emit()
				game_completed.emit()
				SignalBus.increase_health.emit(150)
			else:
				generate_target()
		else:
			cur_in_a_row = 0

func generate_target() -> void:
	should_be_pressed = randi_range(1,9)
	computer.set_text(str(should_be_pressed))

func enter_game() -> void:
	game_entered = true
	generate_target()

func _on_area_entered(area: Area2D) -> void:
	if (not game_entered and game_started and
		multiplayer.get_unique_id() == Lobby.HOST_ID and
		area.is_in_group('feet')):
		enter_game()
