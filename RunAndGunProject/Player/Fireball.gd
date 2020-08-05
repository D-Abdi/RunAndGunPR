extends Area2D

export(float) var speed = 300

onready var animation = $AnimationPlayer

var direction = 0

func _ready() -> void:
	set_as_toplevel(true)
	animation.play("size")
	
func _physics_process(delta: float) -> void:
	position.x += direction * speed * delta

func _on_Fireball_body_entered(body: Node) -> void:
	if body.is_a_parent_of(self):
		return
	if "Walker" in body.name:
		body.dead()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	pass # Replace with function body.
