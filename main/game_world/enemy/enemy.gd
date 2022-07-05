extends Area3D
class_name Enemy

@export var speed: float = 1.0

@onready var path_follow: PathFollow3D = get_parent()
@onready var sprite: MeshInstance3D = $MeshInstance3D

func _process(delta) -> void:
	path_follow.offset += speed * delta
	position.y = path_follow.unit_offset / 32.0
