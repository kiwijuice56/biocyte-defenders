extends Node3D
class_name TowerPlacer

@export var mouse_catcher_path: NodePath
@export var tower_file_paths: Array[String]

var mouse_catcher: MouseCatcher
var temporary_tower: Tower

func _ready() -> void:
	set_process(false)
	mouse_catcher = get_node(mouse_catcher_path)

func create_tower(id: int) -> void:
	var new_tower: Tower = load(tower_file_paths[id]).instantiate()
	new_tower.disabled = true
	temporary_tower = new_tower
	add_child(new_tower)
	set_process(true)

func place_tower() -> void:
	set_process(false)
	temporary_tower.call_deferred("queue_free")

func _process(delta: float) -> void:
	if temporary_tower:
		temporary_tower.position = mouse_catcher.mouse_position
		temporary_tower.position.y += 0.5
