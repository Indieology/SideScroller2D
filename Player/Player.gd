extends CharacterBody2D


const SPEED = 115.0
const JUMP_VELOCITY = -275.0

var gravity = 986
var direction = Vector2.ZERO

enum states {IDLE, RUN, JUMP, FALL, SLIDE, SHOOT, SHOOT_FALL}
var current_state = states.IDLE

var last_shoot_animation = "Shoot1"

func _ready():
	$SlideTimer.stop()
	$ShootTimer.stop()
	current_state = states.RUN

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	#direction = Input.get_axis("ui_left", "ui_right")
	direction = 1
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		current_state = states.JUMP
	elif velocity.y > 15 and $ShootTimer.is_stopped():
		if Input.is_action_just_pressed("shoot"):
			current_state = states.SHOOT_FALL
		else:
			current_state = states.FALL
	elif Input.is_action_just_pressed("shoot"):
		if current_state == states.JUMP:
			current_state = states.SHOOT_FALL
		else:
			current_state = states.SHOOT
	elif direction and current_state != states.JUMP and $SlideTimer.is_stopped() and $ShootTimer.is_stopped():
		current_state = states.RUN
		if Input.is_action_just_pressed("slide"):
			current_state = states.SLIDE
	elif $JumpTimer.is_stopped() and $SlideTimer.is_stopped() and $ShootTimer.is_stopped():
		if direction:
			current_state = states.RUN
		else:
			current_state = states.IDLE
		if Input.is_action_just_pressed("slide"):
			current_state = states.SLIDE
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
			match last_shoot_animation:
				"Shoot1":
					$AnimatedSprite2D.set_frame_and_progress(4,0)
					last_shoot_animation = "none"
				"Shoot2":
					$AnimatedSprite2D.set_frame_and_progress(5,0)
					last_shoot_animation = "none"
				"Shoot3":
					$AnimatedSprite2D.set_frame_and_progress(6,0)
					last_shoot_animation = "none"
				"Shoot4":
					$AnimatedSprite2D.set_frame_and_progress(7,0)
					last_shoot_animation = "none"
				"Shoot5":
					$AnimatedSprite2D.set_frame_and_progress(0,0)
					last_shoot_animation = "none"
				"Shoot6":
					$AnimatedSprite2D.set_frame_and_progress(1,0)
					last_shoot_animation = "none"
				"Shoot7":
					$AnimatedSprite2D.set_frame_and_progress(2,0)
					last_shoot_animation = "none"
				"Shoot8":
					$AnimatedSprite2D.set_frame_and_progress(3,0)
					last_shoot_animation = "none"
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
		states.SLIDE:
			velocity.x = direction * SPEED
			$Label.text = "SLIDE"
			$AnimatedSprite2D.play("Slide")
			if $SlideTimer.time_left <= 0:
				$SlideTimer.start()
		states.SHOOT:
			velocity.x = direction * SPEED
			$Label.text = "SHOOT"
			if $ShootTimer.time_left <= 0:
				$ShootTimer.start()
				match $AnimatedSprite2D.frame:
					0:
						$AnimatedSprite2D.play("Shoot1")
						last_shoot_animation = "Shoot1"
					1:
						$AnimatedSprite2D.play("Shoot2")
						last_shoot_animation = "Shoot2"
					2:
						$AnimatedSprite2D.play("Shoot3")
						last_shoot_animation = "Shoot3"
					3:
						$AnimatedSprite2D.play("Shoot4")
						last_shoot_animation = "Shoot4"
					4:
						$AnimatedSprite2D.play("Shoot5")
						last_shoot_animation = "Shoot5"
					5:
						$AnimatedSprite2D.play("Shoot6")
						last_shoot_animation = "Shoot6"
					6:
						$AnimatedSprite2D.play("Shoot7")
						last_shoot_animation = "Shoot7"
					7:
						$AnimatedSprite2D.play("Shoot8")
						last_shoot_animation = "Shoot8"
		states.SHOOT_FALL:
			$Label.text = "SHOOT FALL"
			if $ShootTimer.time_left <= 0:
				$ShootTimer.start()
				$AnimatedSprite2D.play("Shoot_Fall")
			if is_on_floor():
				current_state = states.RUN
	if current_state == states.SLIDE:
		$SlideCollisionShape.set_deferred("disabled", false)
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		$SlideCollisionShape.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", false)
	
	
