extends Node2D

@export var BULLET_SPEED = 300

func _ready():
	$AnimatedSprite2D.play("Bullet")
	$LifetimeTimer.start()

func _process(delta):
	if $LifetimeTimer.is_stopped():
		$AnimatedSprite2D.play("Explosion")
	position.x = position.x + 3.5

func _on_area_entered(area):
	$AnimatedSprite2D.play("Explosion")

func _on_animated_sprite_2d_animation_finished():
	queue_free()
