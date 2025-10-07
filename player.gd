extends CharacterBody2D

const SPEED = 300.0
const DASH_SPEED = 800.0
const DASH_DURATION = 0.2
const PUSH_FORCE = 1000.0

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



	# Sideways movement
	# --------------------------------------------------

	# Get input direction
	var direction = Vector2.ZERO


	# Left and right movement
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1

	# Normalize diagonal movement
	# This makes jumps very weird
	# if direction.length() > 0:
	# 	direction = direction.normalized()

	# Check for current-direction-dash input
	if Input.is_action_just_pressed("ui_select") and direction.length() > 0 and not is_dashing:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_direction = direction

	# Normal movement
	if direction.length() > 0:
		velocity.x = direction.x * SPEED

	# --------------------------------------------------





	# Gravity
	velocity.y += 20 * SPEED * delta

	# Jumping

	if not in_jump and Input.is_key_pressed(KEY_W):
		velocity.y -= 10 * SPEED
		in_jump = true

	# Check if on floor to reset jump
	if is_on_floor() and in_jump:
		in_jump = false





	velocity = velocity.lerp(Vector2.ZERO, 0.1)
	move_and_slide()



	#   Your player needs to apply force when colliding:
	# In player.gd, detect collision and push
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_FORCE)
