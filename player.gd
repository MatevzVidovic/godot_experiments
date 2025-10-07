extends CharacterBody2D

const SPEED = 300.0
const DASH_SPEED = 800.0
const DASH_DURATION = 0.2

var in_jump = false

var is_dashing = false
var dash_timer = 0.0
var dash_direction = Vector2.ZERO

func _physics_process(delta):
	# Handle dashing
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
		else:
			velocity = dash_direction * DASH_SPEED
			move_and_slide()
			return

	# Get input direction
	var direction = Vector2.ZERO

	# Gravity
	velocity.y += 200 * delta

	# Left and right movement
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1

	if not in_jump and Input.is_key_pressed(KEY_W):
		direction.y -= 400
		in_jump = true

	# Check if on floor to reset jump
	if is_on_floor() and in_jump:
		in_jump = false

	# Normalize diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

	# Check for current-direction-dash input
	if Input.is_action_just_pressed("ui_select") and direction.length() > 0 and not is_dashing:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_direction = direction

	# Normal movement
	if direction.length() > 0:
		velocity = direction * SPEED
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.1)

	move_and_slide()
