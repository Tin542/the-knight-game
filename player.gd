extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

@onready var anim_sprite = get_node("AnimatedSprite2D")
var is_attacking = false  # Track if the character is in the middle of an attack
@onready var attack_timer = Timer.new()  # Timer to handle attack duration

func _ready() -> void:
	# Initialize the attack timer and add it as a child
	attack_timer.one_shot = true
	attack_timer.connect("timeout", Callable(self, "_on_attack_finished"))  # Use Callable in Godot 4
	add_child(attack_timer)

func _physics_process(delta: float) -> void:
	# Handle attack only if not already attacking and the character is on the floor (not jumping)
	if Input.is_action_just_pressed("ui_attack") and not is_attacking and is_on_floor():
		is_attacking = true
		velocity = Vector2.ZERO  # Stop movement when attacking
		anim_sprite.play("Attack")
		attack_timer.start(0.5)  # Attack lasts for 0.5 seconds (adjust as necessary)
		return  # Stop other actions while attacking

	# Handle gravity and movement only when not attacking
	if not is_attacking:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim_sprite.play("Jump")

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction == -1: 
			anim_sprite.flip_h = true
		elif direction == 1:
			anim_sprite.flip_h = false

		if direction:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim_sprite.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				anim_sprite.play("Idle")

	# Move the character
	move_and_slide()

# Callback when attack timer finishes
func _on_attack_finished() -> void:
	is_attacking = false  # Allow other inputs after attack is finished
