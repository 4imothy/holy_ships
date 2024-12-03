extends Sprite2D

# Export variables to control the bobbing behavior
@export var amplitude: float = 3.0 # How far up and down it moves
@export var speed: float = 5.0 # How fast it moves

var time_elapsed: float = 0.0

# Variable to track the original position
var original_y: float

func _ready():
	# Save the original Y position
	original_y = position.y

func _process(delta: float):
	time_elapsed += delta
	position.y = original_y + amplitude * sin(speed * time_elapsed)
