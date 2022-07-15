extends Area3D
class_name Attack

@export var move_speed: float = 1.0
@export var pierce: int
@export var damage: int

var initial_dir: Vector3:
	set(value):
		value.y = 0
		initial_dir = value.normalized()

func _ready() -> void:
	connect("area_entered", hit_target)
	initial_dir.y = 0

# Called when the projectile collides with an enemy
func hit_target(enemy: Area3D) -> void:
	pierce -= 1
	if pierce == 0:
		queue_free()

func _physics_process(delta: float) -> void:
	position += initial_dir * delta * move_speed
