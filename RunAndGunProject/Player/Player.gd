extends KinematicBody2D

const Fireball = preload("res://Player/Fireball.tscn")

const MOVE_SPEED = 200
const JUMP_FORCE = 500
const GRAVITY = 30
const MAX_FALL_SPEED = 600

var facing_right = false
var y_velo = 0

var state_machine

enum {
	MOVE,
	ATTACK
}

var state = MOVE

func _ready() -> void:
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.start("idle")
	$AnimationTree.active = true

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var move_dir = 0
	if Input.is_action_pressed("ui_right"):
		move_dir += 1
	if Input.is_action_pressed("ui_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1) * delta)
	
	var grounded = is_on_floor()
	y_velo += GRAVITY
	if grounded and Input.is_action_just_pressed("ui_up"):
		y_velo = -JUMP_FORCE
	if grounded and y_velo >= 5:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		
	var roof = is_on_ceiling()
	if roof:
		y_velo += GRAVITY
	
	if facing_right and move_dir > 0:
		self.flip()
	if !facing_right and move_dir < 0:
		self.flip()
		
	if grounded:
		if move_dir == 0:
			state_machine.travel("idle")
		else:
			state_machine.travel("walk")
	else:
		state_machine.travel("jump")
		
	if Input.is_action_just_pressed("shoot"):
		state = ATTACK

func attack_state(delta):
	state_machine.travel("attack")
	var grounded = is_on_floor()
	y_velo += GRAVITY
	if grounded and Input.is_action_just_pressed("ui_up"):
		y_velo = -JUMP_FORCE
	if grounded and y_velo >= 5:
		y_velo = 5
	if y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED

	var roof = is_on_ceiling()
	if roof:
		y_velo += GRAVITY
	

func attack_finished():
	state = MOVE
	
func flip():
	facing_right = !facing_right
	$Sprite.flip_h = !$Sprite.flip_h
	
sync func _shoot():
	var fireball = Fireball.instance()
	add_child(fireball)
	fireball.global_position = global_position
	fireball.direction = -1 if facing_right == true else 1
	
func death():
	state_machine.travel("death")
	set_physics_process(false)
	
func hurt():
	state_machine.travel("hurt")
	
func _on_Hurtbox_area_entered(area: Area2D) -> void:
	hurt()
