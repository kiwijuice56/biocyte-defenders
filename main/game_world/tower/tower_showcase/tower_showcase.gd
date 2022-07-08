extends Node3D
class_name TowerShowcase
# Debug class to present all upgrade paths of a tower

@export var tower: PackedScene
@export var grid_cells: int = 8
@export var rot_speed: float = 2
@export var distance: float = 2

func _ready() -> void:
	# ProjectSettings.set_setting("rendering/limits/global_shader_variables/buffer_size", 800000)
	# ProjectSettings.save()
	
	var tower_cnt: int = 0
	for top in range(0, 5):
		for mid in range(0, 5):
			for bot in range(0, 5):
				var main_path_cnt: int = int(top > 2) + int(mid > 2) + int(bot > 2)
				var side_path_cnt: int = int(top > 0) + int(mid > 0) + int(bot > 0)
				var max_path: int = max(top, max(mid, bot))
				if main_path_cnt > 1 or side_path_cnt > 2:
					continue 
					
				var new_tower: Tower = tower.instantiate()
				add_child(new_tower)
				
				new_tower.upgrades = [top, mid, bot]
				new_tower.position.x = (tower_cnt % grid_cells) * distance
				new_tower.position.z = int(tower_cnt / grid_cells) * distance
				tower_cnt += 1
				
				new_tower.update_upgrade_status()

func _process(delta) -> void:
	for child in get_children():
		if child is Camera3D or child is DirectionalLight3D or child is Label:
			continue
		child.rotation.y += rot_speed * delta
