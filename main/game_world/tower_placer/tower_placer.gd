extends Node3D
class_name TowerPlacer
# Creates and places towers with mouse input from MouseCatcher

@export var mouse_catcher: MeshInstance3D
@export var tower_file_paths: Array[String]

var tower_to_place: Tower

func _ready() -> void:
	set_process(false)

# When placing a tower, move it to the mouse position
func _process(_delta: float) -> void:
	if tower_to_place:
		tower_to_place.position = mouse_catcher.mouse_position
		tower_to_place.position.y += 0.5
		tower_to_place.valid_placement = tower_to_place.colliding_count == 0

# Initialize a tower and prepare it for placement
func create_tower(id: int) -> void:
	var new_tower: Tower = load(tower_file_paths[id]).instantiate()
	tower_to_place = new_tower
	add_child(new_tower)
	
	new_tower.position.y = -1
	new_tower.range_visible = true
	new_tower.active = false
	set_process(true)

# Finalize the position of a tower being placed and activate it
func place_tower() -> void:
	set_process(false)
	if not tower_to_place.valid_placement:
		tower_to_place.call_deferred("queue_free")
		return
	tower_to_place.range_visible = false
	tower_to_place.active = true
