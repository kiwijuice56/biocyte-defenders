extends Area3D
class_name Enemy

@export var speed: float = 1.0

@onready var path_follow: PathFollow3D = get_parent()

func _process(delta) -> void:
	path_follow.offset += speed * delta
