extends CharacterBody2D


const SPEED = 115.0
const JUMP_VELOCITY = -275.0

var gravity = 986
var direction = Vector2.ZERO

enum states {IDLE, RUN, JUMP, FALL}
var current_state = states.IDLE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	#direction = Input.get_axis("ui_left", "ui_right")
	direction = 1
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		current_state = states.JUMP
	elif velocity.y > 15:
		current_state = states.FALL
	elif direction and current_state != states.JUMP:
		current_state = states.RUN
	elif $JumpTimer.is_stopped():
		if direction:
			current_state = states.RUN
		else:
			current_state = states.IDLE
	run_current_state()
	move_and_slide()
	#print(velocity)

func run_current_state():
	
	match current_state:
		states.IDLE:
			$Label.text = "IDLE"
			velocity.x = move_toward(velocity.x, 0, SPEED)
			$AnimatedSprite2D.play("Idle")
		states.RUN:
			$Label.text = "RUN"
			velocity.x = direction * SPEED
			$AnimatedSprite2D.play("Run_Aim")
		states.JUMP:
			$Label.text = "JUMP"
			$AnimatedSprite2D.play("Jump")
			velocity.x = direction * SPEED
			if $JumpTimer.time_left <= 0:
				velocity.y = JUMP_VELOCITY
				$JumpTimer.start()
		states.FALL:
			$Label.text = "FALL"
			$AnimatedSprite2D.play("Fall")
	
	
