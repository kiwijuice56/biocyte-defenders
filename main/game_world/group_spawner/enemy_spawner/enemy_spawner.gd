extends Node3D
class_name EnemySpawner
# Spawns one type of enemy at a fixed interval

var path: Path3D
var enemy_spawn_timer: Timer

var group: EnemyGroup
var enemies_spawned: int = 0

func _ready() -> void:
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.one_shot = true
	enemy_spawn_timer.connect("timeout", spawn_enemy)

func initialize(group: EnemyGroup, path: Path3D) -> void:
	self.group = group
	self.path = path
	
	enemy_spawn_timer.start(group.delay)

func spawn_enemy() -> void:
	var path_follow: PathFollow3D = create_path_follow()
	
	var new_enemy = group.enemy_scene.instantiate()
	
	path_follow.add_child(new_enemy)
	path.add_child(path_follow)
	
	enemies_spawned += 1
	if enemies_spawned < group.count:
		enemy_spawn_timer.start(group.delay)
	else:
		queue_free()

static func create_path_follow() -> PathFollow3D:
	var path_follow: PathFollow3D = PathFollow3D.new()
	path_follow.cubic_interp = false
	path_follow.rotation_mode = PathFollow3D.ROTATION_NONE
	return path_follow
