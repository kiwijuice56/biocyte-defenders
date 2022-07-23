extends Node3D
class_name TowerPlacer
# Creates and places towers with mouse input from MouseCatcher

@export var mouse_catcher: MeshInstance3D
@export var tower_file_paths: Array[String]

var towers: Array[Tower]
var tower_to_place: Tower
var selected_tower: Tower

func _ready() -> void:
	set_process(false)
	set_process_input(false)
	
	# PointerArea is not loaded at this point
	await mouse_catcher.ready
	mouse_catcher.pointer_area.connect("tower_clicked", tower_clicked)
	mouse_catcher.pointer_area.connect("focus_lost", focus_lost)
	
	# Cache towers in memory
	for tower_file_path in tower_file_paths:
		var tower: Tower = load(tower_file_path).instantiate()
		tower.visible = false
		add_child(tower)
		# Move out of range
		tower.position.y = -1000 
		towers.append(tower)

# When placing a tower, move it to the mouse position
func _process(_delta: float) -> void:
	if tower_to_place:
		tower_to_place.position = mouse_catcher.mouse_position
		tower_to_place.position.y += 0.5
		tower_to_place.valid_placement = tower_to_place.colliding_count == 0

func _input(event: InputEvent) -> void:
	if not selected_tower:
		return
	var tower_upgrades: Array = selected_tower.upgrades.duplicate()
	if event.is_action_pressed("upgrade_first", false):
		selected_tower.upgrades[0] += 1
	if event.is_action_pressed("upgrade_second", false):
		selected_tower.upgrades[1] += 1
	if event.is_action_pressed("upgrade_third", false):
		selected_tower.upgrades[2] += 1
	if tower_upgrades != selected_tower.upgrades:
		selected_tower.update_upgrade_status()

# Initialize a tower and prepare it for placement
func create_tower(id: int) -> void:
	var new_tower: Tower = towers[id].duplicate()
	tower_to_place = new_tower
	add_child(new_tower)
	
	new_tower.initialize()
	
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
	tower_to_place.place()

func tower_clicked(tower: Tower) -> void:
	selected_tower = tower
	selected_tower.range_visible = true
	set_process_input(true)

func focus_lost() -> void:
	if selected_tower:
		selected_tower.range_visible = false
	set_process_input(false)
