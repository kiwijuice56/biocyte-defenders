extends MeshInstance3D
class_name MouseCatcher
# Captures and converts mouse input to 3D space

signal mouse_entered
signal mouse_exited

@export var camera_path: NodePath
@export var ray_length: int = 32

@onready var pointer_area: Area3D = get_node("PointerArea")

var cam: Camera3D

var mouse_position: Vector3
var mouse_caught: bool = false

func _ready() -> void:
	cam = get_node(camera_path) as Camera3D
	assert(cam != null)

func _input(event) -> void:
	if not event is InputEventMouse:
		return
	# https://docs.godotengine.org/en/3.0/tutorials/physics/ray-casting.html#d-ray-casting-from-screen
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var from_dir: Vector3 = cam.project_ray_origin(mouse_pos)
	var to_dir: Vector3 = from_dir + cam.project_ray_normal(mouse_pos) * ray_length
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().get_direct_space_state()
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_query.to = to_dir
	ray_query.from = from_dir
	var result: Dictionary = space_state.intersect_ray(ray_query)
	if "position" in result:
		mouse_position = result["position"]
		pointer_area.global_transform.origin = result["position"]
		if not mouse_caught:
			emit_signal("mouse_entered")
	elif mouse_caught:
		emit_signal("mouse_exited")
	mouse_caught = "position" in result
