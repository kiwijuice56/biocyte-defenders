extends Node3D
class_name Tower

@export var base_range: float 

@onready var indicator_mesh: MeshInstance3D = get_node("TargetingArea/IndicatorMesh")

var active: bool = false
var colliding_count: int = 0

var range_visible: bool = false:
	set(value):
		range_visible = value
		indicator_mesh.visible = range_visible
		indicator_mesh.mesh.radius = base_range
var valid_placement: bool = false:
	set(value):
		valid_placement = value
		if valid_placement:
			indicator_mesh.get_surface_override_material(0).set("albedo_color", Color("#19222b66"))
		else:
			indicator_mesh.get_surface_override_material(0).set("albedo_color", Color("#6b212ca0"))

func _ready() -> void:
	$PlacementArea.connect("area_entered", area_entered_placement_area)
	$PlacementArea.connect("area_exited", area_exited_placement_area)

func area_entered_placement_area(_area: Area3D) -> void:
	colliding_count += 1

func area_exited_placement_area(_area: Area3D) -> void:
	colliding_count -= 1
