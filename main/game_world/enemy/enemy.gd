extends Area3D
class_name Enemy
# Base class for all bacteria and virus enemies

@export var move_speed: float = 1.0

@onready var path_follow: PathFollow3D = get_parent()

func _process(delta) -> void:
	path_follow.offset += move_speed * delta
	# Apply small, almost invisible y offset for layering by progress on track
	position.y = path_follow.unit_offset / 32.0
