extends ParallaxBackground

var scrolling_speed = 100.0
@onready var parallax_layer2 = $ParallaxLayer2 # Replace 'ParallaxLayer2' with the actual node path
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Check if parallax_layer2 exists and adjust its motion offset
	if parallax_layer2:
		parallax_layer2.motion_offset.x -= scrolling_speed * delta
