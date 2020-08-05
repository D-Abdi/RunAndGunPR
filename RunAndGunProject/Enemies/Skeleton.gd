extends KinematicBody2D

const GRAVITY = 30
const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2(0,0)
var direction = 1 
var facing_right = false

func _physics_process(delta: float) -> void:
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	$AnimationPlayer.play("walk")
	velocity = move_and_slide(velocity, FLOOR * delta)
	
	if is_on_wall():
		direction = direction * -1
		flip()
		
	if $RayCast2D.is_colliding() == false: 
		direction = direction * -1
		flip()
		
func flip():
	facing_right = !facing_right
	$Sprite.flip_h = !$Sprite.flip_h
	$RayCast2D.position.x *= -1
	

