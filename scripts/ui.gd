extends Camera2D

# Define the two colors to alternate between
var color1 = Color(0.5, 0.5, 0.5, 1)
var color2 = Color(1, 0, 0, 1)

@onready var timer = $Timer
@onready var label = $FireMessage
# Track the current color
var is_color1 = true

func _ready():
	# Set timer to loop, connect signal with Callable, and start it
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer.start()
	label.modulate = color1
	#print("Timer started")

# Function to handle the timer's timeout signal
func _on_Timer_timeout():
	#print("Color changed")
	# Toggle the color
	if is_color1:
		label.modulate = color2
	else:
		label.modulate = color1
	is_color1 = !is_color1
