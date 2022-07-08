extends Node3D
class_name Tower
# Base class for all player towers

@export var attack_range: float = 2.5:
	set(value):
		attack_range = value
		if indicator_mesh:
			indicator_mesh.radius = attack_range
@export var cooldown_time: float = 1.5:
	set(value):
		cooldown_time = value
		$CooldownTimer.wait_time = cooldown_time
@export var attack: PackedScene
@export var base_model: PackedScene

@onready var indicator_mesh: MeshInstance3D = get_node("TargetingArea/IndicatorMesh")

enum TargetingType { FIRST, LAST, CLOSE, STRONG }

var model: TowerModel
var upgrades: Array[int] = [0, 0, 0]:
	set(value):
		upgrades = value
		$UpgradeLabel.text = str(upgrades)
		update_upgrade_status()
var target_type: TargetingType = TargetingType.FIRST
var targets: Dictionary = {}
var active: bool = false
var colliding_count: int = 0

var range_visible: bool = false:
	set(value):
		range_visible = value
		indicator_mesh.visible = range_visible
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
	
	$TargetingArea.connect("area_entered", area_entered_targeting_area)
	$TargetingArea.connect("area_exited", area_exited_targeting_area)
	
	$CooldownTimer.connect("timeout", attack_cooldown_ended)
	
	# Initialize stat traits as setter functions are not called in the editor
	$CooldownTimer.wait_time = cooldown_time
	indicator_mesh.mesh.radius = attack_range
	
	update_upgrade_status()

func area_entered_placement_area(_area: Area3D) -> void:
	colliding_count += 1

func area_exited_placement_area(_area: Area3D) -> void:
	colliding_count -= 1

func area_entered_targeting_area(area: Area3D) -> void:
	targets[area] = true
	$CooldownTimer.start()

func area_exited_targeting_area(area: Area3D) -> void:
	targets.erase(area)
	$CooldownTimer.stop()

func attack_cooldown_ended() -> void:
	# rotate mesh
	pass

func upgrade_threshold_met(priority: Array[int]) -> bool:
	for i in range(len(upgrades)):
		if upgrades[i] < priority[i]:
			return false
	return true

func update_upgrade_status() -> void:
	if model:
		model.queue_free()
	model = base_model.instantiate()
	add_child(model)
