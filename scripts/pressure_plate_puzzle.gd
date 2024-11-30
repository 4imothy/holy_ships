extends Node2D

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if multiplayer.get_unique_id() == Lobby.HOST_ID:
		start_game()
	

func start_game() -> void:
	if multiplayer.get_unique_id() == Lobby.HOST_ID:
		computer.set_gate(1)
		game_started = true
	
func stepped_on(name: String) -> void:
	if multiplayer.get_unique_id() == Lobby.HOST_ID:
		if int(name) == should_be_pressed:
			print('complete')
		else:
			print('wrong')

func enter_game() -> void:
	should_be_pressed = randi_range(1,9)
	computer.set_text(str(should_be_pressed))

func _on_area_entered(area: Area2D) -> void:
	if (not game_entered and game_started and
	   multiplayer.get_unique_id() == Lobby.HOST_ID and
	   area.is_in_group('feet')):
		enter_game()
