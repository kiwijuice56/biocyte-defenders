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
			indicator_mesh.material_override.set("albedo_color", Color("#19222b66"))
		else:
			indicator_mesh.material_override.set("albedo_color", Color("#6b212ca0"))

func _ready() -> void:
	$PlacementArea.connect("area_entered", area_entered_placement_area)
	$PlacementArea.connect("area_exited", area_exited_placement_area) 
	
	$TargetingArea.connect("area_entered", area_entered_targeting_area)
	$TargetingArea.connect("area_exited", area_exited_targeting_area)
	
	$CooldownTimer.connect("timeout", attack_cooldown_ended)
	
	# Initialize stat traits as setter functions are not called in the editor
	$CooldownTimer.wait_time = cooldown_time
	indicator_mesh.mesh.radius = attack_range
	$TargetingArea/CollisionShape3D.shape.radius = attack_range
	
	update_upgrade_status()

func area_entered_placement_area(_area: Area3D) -> void:
	colliding_count += 1

func area_exited_placement_area(_area: Area3D) -> void:
	colliding_count -= 1

func area_entered_targeting_area(area: Area3D) -> void:
	targets[area] = true
	if $CooldownTimer.is_stopped():
		$CooldownTimer.start()

func area_exited_targeting_area(area: Area3D) -> void:
	targets.erase(area)

func attack_cooldown_ended() -> void:
	if not active:
		return
	$CooldownTimer.start()
	
	var target: Enemy = get_target()
	if target == null:
		return
	rotation.x = 0
	rotation.z = 0
	look_at(target.global_transform.origin)
	
	model.animate_shoot()
	
	var new_attack: Attack = attack.instantiate() as Attack
	new_attack.initial_dir = target.global_transform.origin - global_transform.origin
	get_tree().root.add_child(new_attack)
	new_attack.global_transform.origin = global_transform.origin

func get_target() -> Enemy:
	if len(targets) > 0:
		var unit_order: Array[Enemy] = targets.keys()
		unit_order.sort_custom(path_sort)
		match target_type:
			TargetingType.FIRST:
				return unit_order[0]
			TargetingType.LAST:
				return unit_order[len(unit_order) - 1]
	return null

func path_sort(a: Enemy, b: Enemy) -> bool:
	return a.path_follow.unit_offset > b.path_follow.unit_offset

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
	move_child(model, 0)
